import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/storage.dart';

/// Oyuncu ayarları. Değişmez (immutable) bir değer sınıfı.
class Settings {
  const Settings({
    this.music = true,
    this.sfx = true,
    this.vibration = false,
  });

  final bool music;
  final bool sfx;
  final bool vibration;

  /// Rulo başına ipucu hakkı (herkes için aynı). Bitince reklamla sınırsız ek ipucu alınır.
  static const hintsPerReel = 3;

  Settings copyWith({
    bool? music,
    bool? sfx,
    bool? vibration,
  }) =>
      Settings(
        music: music ?? this.music,
        sfx: sfx ?? this.sfx,
        vibration: vibration ?? this.vibration,
      );

  Map<String, dynamic> toJson() => {
        'music': music,
        'sfx': sfx,
        'vibration': vibration,
      };

  factory Settings.fromJson(Map<String, dynamic> json) {
    const defaults = Settings();
    // Kayıt bozuksa ya da eski sürümden kaldıysa varsayılan değere dönülür.
    bool readBool(String key, bool fallback) {
      final value = json[key];
      return value is bool ? value : fallback;
    }

    return Settings(
      music: readBool('music', defaults.music),
      sfx: readBool('sfx', defaults.sfx),
      vibration: readBool('vibration', defaults.vibration),
    );
  }
}

/// Ayarları okuyan/değiştiren kontrolcü. Her değişiklik cihaza yazılır.
class SettingsController extends Notifier<Settings> {
  @override
  Settings build() =>
      Settings.fromJson(ref.read(storageProvider).readSettings());

  void _save(Settings next) {
    state = next;
    ref.read(storageProvider).writeSettings(next.toJson());
  }

  void setMusic(bool enabled) => _save(state.copyWith(music: enabled));
  void setSfx(bool enabled) => _save(state.copyWith(sfx: enabled));
  void setVibration(bool enabled) => _save(state.copyWith(vibration: enabled));
}

final settingsProvider =
    NotifierProvider<SettingsController, Settings>(SettingsController.new);
