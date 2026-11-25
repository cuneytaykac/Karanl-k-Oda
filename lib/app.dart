import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/audio/audio_binding.dart';
import 'core/router/router.dart';
import 'core/theme/theme.dart';
import 'features/ads/presentation/providers/ads_coordinator.dart';
import 'features/splash/presentation/screen/splash_overlay.dart';
import 'features/splash/presentation/view_model/splash_view_model.dart';
import 'l10n/l10n.dart';

class DarkRoomApp extends ConsumerWidget {
  const DarkRoomApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(audioBindingProvider);
    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.appTitle,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      theme: koTheme(),
      routerConfig: ref.watch(routerProvider),
      builder: (context, child) => Stack(
        children: [
          child ?? const SizedBox.shrink(),
          const _SplashLayer(),
        ],
      ),
    );
  }
}

/// Açılış sahnesi bitene kadar uygulamanın üstünde durur; uygulama altında yüklenir.
class _SplashLayer extends ConsumerWidget {
  const _SplashLayer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final done = ref.watch(splashViewModelProvider(reduceMotion).select((s) => s.done));
    // Sahne biter bitmez, ilk açılışta da: gerekiyorsa onay formu ve iPhone'daki
    // takip izni (ATT), sonra reklamlar. Apple incelemesi izin penceresinin
    // temiz kurulumdan hemen sonra görünmesini istiyor; öğreticiden sonraya
    // bırakınca inceleme sırasında hiç çıkmıyordu. Bu akış bitmeden reklam ağı
    // başlamaz. İlk rulo yine geçiş reklamsız (AdBreakPolicy).
    if (done) {
      ref.watch(adsStartupProvider);
      return const SizedBox.shrink();
    }
    return const Material(
      type: MaterialType.transparency,
      child: SplashOverlay(),
    );
  }
}
