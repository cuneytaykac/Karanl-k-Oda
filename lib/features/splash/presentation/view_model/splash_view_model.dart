import 'package:flutter/animation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/audio/audio.dart';

/// Hangi açılış sahnesi oynasın:
/// - [SplashStyle.lamp]: lamba titreyerek yanar, nonogram ızgarası dolup fotoğraf makinesi olur.
/// - [SplashStyle.tray]: banyo tepsisine damla düşer, sıvıda negatif belirip fotoğrafa döner.
enum SplashStyle {
  lamp(Duration(milliseconds: 3200), [(0.08, Sfx.lamp)]),
  tray(Duration(milliseconds: 3400), [(0.26, Sfx.drip), (0.72, Sfx.found)]);

  const SplashStyle(this.duration, this.cues);

  /// Sahnenin tam süresi (her açılışta aynı).
  final Duration duration;

  /// Zaman çizelgesindeki sesler: (an 0–1, ses).
  final List<(double, Sfx)> cues;
}

const kSplashStyle = SplashStyle.tray;

/// Açılış sahnesinin durumu.
class SplashState {
  const SplashState({required this.t, required this.done});

  /// Zaman çizelgesi 0–1.
  final double t;

  /// Sahne bitti: uygulama görünür.
  final bool done;
}

/// Açılış sahnesinin zamanlayıcısı. Uygulama bu sahnenin altında yüklenir;
/// dokununca sahne hızla sonuna gider.
class SplashViewModel extends Notifier<SplashState> {
  SplashViewModel(this.reduceMotion);

  /// Hareket azaltılmışsa doğrudan son hâli gösterip kısa bir solmayla geçer.
  final bool reduceMotion;

  static const _skipDuration = Duration(milliseconds: 280);

  /// Bu andan sonra dokunmak bir şey değiştirmez (sahne zaten bitiyor).
  static const _skipUntil = 0.86;

  final _style = kSplashStyle;
  late final Ticker _ticker;
  final _played = <int>{};

  // Şu anki bölüm: [_from] değerinden 1'e, [_span] sürede, [_curve] eğrisiyle.
  Duration _now = Duration.zero, _start = Duration.zero;
  double _from = 0;
  late Duration _span;
  Curve _curve = Curves.linear;

  @override
  SplashState build() {
    _from = reduceMotion ? 0.92 : 0;
    _span = _style.duration * (1 - _from);
    _ticker = Ticker(_tick)..start();
    ref.onDispose(_ticker.dispose);
    return SplashState(t: _from, done: false);
  }

  void _tick(Duration elapsed) {
    _now = elapsed;
    final p = ((elapsed - _start).inMicroseconds / _span.inMicroseconds)
        .clamp(0.0, 1.0);
    final t = _from + (1 - _from) * _curve.transform(p);
    _playCues(t);
    if (p >= 1) _ticker.stop();
    state = SplashState(t: t, done: p >= 1);
  }

  void _playCues(double t) {
    final cues = _style.cues;
    for (var i = 0; i < cues.length; i++) {
      if (t >= cues[i].$1 && _played.add(i)) {
        ref.read(gameAudioProvider).play(cues[i].$2);
      }
    }
  }

  /// Dokunuldu: kalan kısım hızla biter.
  void skip() {
    if (state.t >= _skipUntil || !_ticker.isActive) return;
    _from = state.t;
    _start = _now;
    _span = _skipDuration;
    _curve = Curves.easeOut;
  }
}

final splashViewModelProvider =
    NotifierProvider.family<SplashViewModel, SplashState, bool>(
        SplashViewModel.new);
