import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Oyundaki kısa efektler. Dosyalar: `assets/audio/<ad>.wav` (koddan sentezlendi, telifsiz).
enum Sfx {
  tap, // kare doldur
  cross, // çarpı işaretle
  line, // satır/sütun tamam
  solve, // bulmaca çözüldü
  develop, // banyo tepsisi
  found, // büyüteç ayrıntıyı buldu
  page, // hikâye satırı
  drip,
  // Hikâye anları
  phone, // eski ev telefonu çalıyor
  doorbell, // dükkân kapısının zili
  newspaper, // gazete açılıyor
  letter, // katlı mektup açılıyor
  bag, // torba, içinde makaralar
  reel, // film makarası sarılıyor
  mobile, // cep telefonu: titreşim + zil (Ayşe arıyor)
  message, // mesaj bildirimi
  folder, // kalın dosya tezgâha konuyor
  clock, // hafif tik tak
  lamp; // açılış: lamba düğmesi ve vızıltı

  /// İçerikteki ad ("phone") → efekt; bilinmiyorsa null.
  static Sfx? byName(String? name) =>
      name == null ? null : Sfx.values.asNameMap()[name];
}

/// Ekranlar sesi yalnızca bu arayüzle çalar; ayarlar (Müzik / Efekt) burada uygulanır.
abstract class GameAudio {
  void play(Sfx sfx);

  /// Ayarlardaki Efekt ve Müzik düğmeleri.
  void configure({required bool sfx, required bool music});

  /// Uygulama arka plana geçince ortam sesi durur, dönünce sürer.
  void setForeground(bool foreground);
}

/// Testlerde ve ses yüklenemezse: hiçbir şey çalmaz.
class SilentAudio implements GameAudio {
  const SilentAudio();
  @override
  void play(Sfx sfx) {}
  @override
  void configure({required bool sfx, required bool music}) {}
  @override
  void setForeground(bool foreground) {}
}

/// main.dart'ta gerçek ses ile değiştirilir.
final gameAudioProvider = Provider<GameAudio>((ref) => const SilentAudio());

/// audioplayers ile gerçek ses.
class AudioplayersAudio implements GameAudio {
  AudioplayersAudio._();

  final Map<Sfx, _Voices> _voices = {};
  final Map<Sfx, DateTime> _lastPlayed = {};
  AudioPlayer? _ambience;

  bool _sfxOn = true;
  bool _musicOn = true;
  bool _foreground = true;

  /// Ortam sesi bilerek çok hafif: uzun oyunda yormasın.
  static const _ambienceVolume = 0.35;

  /// Başlarken birden patlamasın; bu sürede yavaşça yükselir.
  static const _fadeIn = Duration(seconds: 3);
  Timer? _fade;

  /// Hızlı sürüklemede aynı efekt üst üste binmesin.
  static const _minGap = {
    Sfx.tap: Duration(milliseconds: 45),
    Sfx.cross: Duration(milliseconds: 45)
  };

  /// Sesleri belleğe yükler. Bir sorun olursa oyun sessiz devam eder.
  static Future<GameAudio> create() async {
    final audio = AudioplayersAudio._();
    try {
      // iPhone'da sessiz düğmesine uy; ekranı uyanık tutma.
      await AudioPlayer.global
          .setAudioContext(AudioContextConfig(respectSilence: true).build());
      for (final s in Sfx.values) {
        // Hızlı dokunuşlarda üst üste binebilen efektlere birden fazla ses.
        final count = (s == Sfx.tap || s == Sfx.cross) ? 3 : 1;
        audio._voices[s] = await _Voices.load('audio/${s.name}.wav', count);
      }
      final amb = AudioPlayer(playerId: 'ambience');
      await amb.setReleaseMode(ReleaseMode.loop);
      await amb.setVolume(0);
      await amb.setSource(AssetSource('audio/ambience.wav'));
      audio._ambience = amb;
    } catch (e, st) {
      debugPrint('Ses yüklenemedi, sessiz devam: $e\n$st');
    }
    return audio;
  }

  @override
  void play(Sfx sfx) {
    if (!_sfxOn || !_foreground) return;
    final gap = _minGap[sfx];
    final now = DateTime.now();
    if (gap != null) {
      final last = _lastPlayed[sfx];
      if (last != null && now.difference(last) < gap) return;
    }
    _lastPlayed[sfx] = now;
    final voices = _voices[sfx];
    if (voices != null) _safely(voices.play, 'Efekt çalınamadı');
  }

  @override
  void configure({required bool sfx, required bool music}) {
    _sfxOn = sfx;
    _musicOn = music;
    _syncAmbience();
  }

  @override
  void setForeground(bool foreground) {
    _foreground = foreground;
    _syncAmbience();
  }

  void _syncAmbience() {
    final amb = _ambience;
    if (amb == null) return;
    final shouldPlay = _musicOn && _foreground;
    final playing = amb.state == PlayerState.playing;
    if (shouldPlay && !playing) {
      _safely(() => amb.setVolume(0), 'Ortam sesi');
      _safely(amb.resume, 'Ortam sesi başlamadı');
      _fadeInAmbience(amb);
    } else if (!shouldPlay && playing) {
      _fade?.cancel();
      _safely(amb.pause, 'Ortam sesi durmadı');
    }
  }

  void _fadeInAmbience(AudioPlayer amb) {
    _fade?.cancel();
    const steps = 15;
    var i = 0;
    _fade = Timer.periodic(_fadeIn ~/ steps, (timer) {
      i++;
      _safely(() => amb.setVolume(_ambienceVolume * i / steps), 'Ortam sesi');
      if (i >= steps) timer.cancel();
    });
  }

  /// Ses hatası oyunu asla durdurmaz.
  static Future<void> _safely(
      Future<Object?> Function() action, String what) async {
    try {
      await action();
    } catch (e) {
      debugPrint('$what: $e');
    }
  }
}

/// Bir efektin sesleri. Düşük gecikme kipinde çalar: Android'de kısa efektler tek
/// bir hafif ses havuzunu (SoundPool) paylaşır. Her efekt için ayrı medya oynatıcı
/// açmak Android'in oynatıcı sınırını aşıyor ve "error (1, -19)" veriyordu.
class _Voices {
  _Voices._(this._players);
  final List<AudioPlayer> _players;
  int _next = 0;

  static Future<_Voices> load(String asset, int count) async {
    final players = <AudioPlayer>[];
    for (var i = 0; i < count; i++) {
      final player = AudioPlayer();
      await player.setPlayerMode(PlayerMode.lowLatency);
      await player.setReleaseMode(ReleaseMode.stop);
      await player.setSource(AssetSource(asset));
      players.add(player);
    }
    return _Voices._(players);
  }

  /// Sıradaki sesi baştan çalar (sırayla döner; en eskisi kesilir).
  Future<void> play() async {
    final player = _players[_next];
    _next = (_next + 1) % _players.length;
    await player.stop();
    await player.resume();
  }
}
