import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../settings/settings.dart';
import 'audio.dart';

/// Sesi uygulamaya bağlar: ayarlardaki Efekt / Müzik düğmeleri sese anında yansır,
/// uygulama arka plana geçince ortam sesi durur. Uygulama açık kaldıkça yaşar.
final audioBindingProvider = Provider<void>((ref) {
  ref.listen<Settings>(settingsProvider, (_, s) {
    ref.read(gameAudioProvider).configure(sfx: s.sfx, music: s.music);
  }, fireImmediately: true);

  final lifecycle = AppLifecycleListener(
    onResume: () => ref.read(gameAudioProvider).setForeground(true),
    onHide: () => ref.read(gameAudioProvider).setForeground(false),
  );
  ref.onDispose(lifecycle.dispose);
});
