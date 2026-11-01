import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/audio/audio_binding.dart';
import 'core/router/router.dart';
import 'core/theme/theme.dart';
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
    final done =
        ref.watch(splashViewModelProvider(reduceMotion).select((s) => s.done));
    if (done) return const SizedBox.shrink();
    return const Material(
      type: MaterialType.transparency,
      child: SplashOverlay(),
    );
  }
}
