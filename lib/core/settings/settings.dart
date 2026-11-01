import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/storage.dart';

/// Oyuncu ayarları. Değişmez (immutable) bir değer sınıfı.
class Settings {
  const Settings({
    this.showMistakes = true,
    this.music = true,
    this.sfx = true,
    this.vibration = false,
    this.stuckHelp = true,
    this.newCaseNotification = false,
  });

  /// Yanlış doldurulan kare kırmızı yanar.
  final bool showMistakes;
  final bool music;
  final bool sfx;
  final bool vibration;
  final bool stuckHelp;
  final bool newCaseNotification;

  /// Rulo başına ipucu hakkı (herkes için aynı). Bitince reklamla sınırsız ek ipucu alınır.
  static const hintsPerReel = 3;

  Settings copyWith({
    bool? showMistakes,
    bool? music,
    bool? sfx,
    bool? vibration,
    bool? stuckHelp,
    bool? newCaseNotification,
  }) =>
      Settings(
        showMistakes: showMistakes ?? this.showMistakes,
        music: music ?? this.music,
        sfx: sfx ?? this.sfx,
        vibration: vibration ?? this.vibration,
        stuckHelp: stuckHelp ?? this.stuckHelp,
        newCaseNotification: newCaseNotification ?? this.newCaseNotification,
      );

  Map<String, dynamic> toJson() => {
        'showMistakes': showMistakes,
        'music': music,
        'sfx': sfx,
        'vibration': vibration,
        'stuckHelp': stuckHelp,
        'newCaseNotification': newCaseNotification,
      };

  factory Settings.fromJson(Map<String, dynamic> json) {
    const defaults = Settings();
    // Kayıt bozuksa ya da eski sürümden kaldıysa varsayılan değere dönülür.
    bool readBool(String key, bool fallback) {
      final value = json[key];
      return value is bool ? value : fallback;
    }

    return Settings(
      showMistakes: readBool('showMistakes', defaults.showMistakes),
      music: readBool('music', defaults.music),
      sfx: readBool('sfx', defaults.sfx),
      vibration: readBool('vibration', defaults.vibration),
      stuckHelp: readBool('stuckHelp', defaults.stuckHelp),
      newCaseNotification:
          readBool('newCaseNotification', defaults.newCaseNotification),
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

  void setShowMistakes(bool enabled) =>
      _save(state.copyWith(showMistakes: enabled));
  void setMusic(bool enabled) => _save(state.copyWith(music: enabled));
  void setSfx(bool enabled) => _save(state.copyWith(sfx: enabled));
  void setVibration(bool enabled) => _save(state.copyWith(vibration: enabled));
  void setStuckHelp(bool enabled) => _save(state.copyWith(stuckHelp: enabled));
  void setNewCaseNotification(bool enabled) =>
      _save(state.copyWith(newCaseNotification: enabled));
}

final settingsProvider =
    NotifierProvider<SettingsController, Settings>(SettingsController.new);
