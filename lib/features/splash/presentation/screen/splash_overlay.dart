import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../view_model/splash_view_model.dart';
import '../widgets/lamp_splash.dart';
import '../widgets/tray_splash.dart';

/// Açılış sahnesi. Uygulama bu sahnenin altında yüklenmeye devam eder; dokununca geçilir.
/// Sahne bitince ([SplashState.done]) uygulama onu ağaçtan çıkarır.
class SplashOverlay extends ConsumerWidget {
  const SplashOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final provider = splashViewModelProvider(reduceMotion);
    final t = ref.watch(provider.select((s) => s.t));
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: ref.read(provider.notifier).skip,
      child: switch (kSplashStyle) {
        SplashStyle.lamp => LampSplash(t: t),
        SplashStyle.tray => TraySplash(t: t),
      },
    );
  }
}
