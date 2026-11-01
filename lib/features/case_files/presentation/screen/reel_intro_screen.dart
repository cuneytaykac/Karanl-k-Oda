import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/film_strip.dart';
import '../../../../core/widgets/ko_button.dart';
import '../../../../core/widgets/ko_icon_button.dart';
import '../../../../l10n/l10n.dart';
import '../../../content/domain/entities/case_file.dart';
import '../view_model/reel_intro_view_model.dart';
import '../widgets/reel_spool.dart';
import '../widgets/safelight_glow.dart';

/// 16 · Rulo başlangıcı: "Rulo 3 / 7 · Göl yolu", dönen makara ve karanlık 10 kare.
/// Makara boşta yavaşça döner, ışık nefes alır. "İlk kareyi banyo et"e basınca makara
/// hızla döner, şerit akar, sonra ilk bulmaca açılır.
class ReelIntroScreen extends ConsumerWidget {
  const ReelIntroScreen({
    super.key,
    required this.file,
    required this.reel,
    required this.onStart,
    required this.onBack,
  });

  final CaseFile file;
  final Reel reel;
  final VoidCallback onStart;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final motion = !reduceMotion;
    final phase = ref.watch(reelIntroViewModelProvider);
    final vm = ref.read(reelIntroViewModelProvider.notifier);
    final starting = phase != ReelIntroPhase.idle;
    ref.listen(reelIntroViewModelProvider, (_, next) {
      if (next == ReelIntroPhase.ready) onStart();
    });

    Widget strip = FilmStrip(
      count: reel.frames.length,
      current: 0,
      semanticLabel: l10n.reelFrames(reel.frames.length),
      // Kareler şerit kayarken sırayla belirir; sonra kırmızı ışık arada bir üstünden geçer.
      entrance: true,
      entranceDelay: const Duration(milliseconds: 300),
      live: true,
    );
    if (motion) {
      strip = strip
          .animate(target: starting ? 1 : 0)
          .slideX(begin: 0, end: -0.35, duration: 600.ms, curve: Curves.easeIn)
          .fade(begin: 1, end: 0.2, duration: 600.ms)
          .animate()
          .slideX(
              begin: 0.4,
              end: 0,
              duration: 700.ms,
              delay: 250.ms,
              curve: Curves.easeOutCubic)
          .fadeIn(duration: 500.ms, delay: 250.ms);
    }

    return Scaffold(
      body: Stack(
        children: [
          // Kırmızı güvenlik ışığı: nefes alır gibi parlayıp söner.
          Positioned(
            top: 90,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Center(
                child: SafelightGlow(motion: motion),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  KoSpacing.m, KoSpacing.m, KoSpacing.m, KoSpacing.l),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: KoIconButton(
                        icon: Icons.chevron_left,
                        label: l10n.back,
                        onPressed: onBack),
                  ),
                  const Spacer(),
                  _maybeAnimate(
                    motion,
                    ReelSpool(winding: starting, motion: motion),
                    (w) => w.animate().fadeIn(duration: 600.ms).scale(
                        begin: const Offset(0.85, 0.85),
                        end: const Offset(1, 1),
                        duration: 700.ms,
                        curve: Curves.easeOutBack),
                  ),
                  const SizedBox(height: KoSpacing.xxl),
                  _maybeAnimate(
                    motion,
                    Column(
                      children: [
                        Text(
                          l10n.reelOf(reel.number, file.totalReels),
                          style: KoText.counter.copyWith(
                              color: KoColor.redText,
                              fontSize: 13,
                              letterSpacing: 1.3),
                        ),
                        const SizedBox(height: KoSpacing.xs),
                        Text(reel.title,
                            style: KoText.display.copyWith(fontSize: 34),
                            textAlign: TextAlign.center),
                        const SizedBox(height: KoSpacing.m),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: KoSpacing.xxl),
                          child: Text(
                            reel.intro,
                            style:
                                KoText.body.copyWith(color: KoColor.textMuted),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    (w) => w
                        .animate()
                        .fadeIn(duration: 500.ms, delay: 150.ms)
                        .slideY(
                            begin: 0.08,
                            end: 0,
                            duration: 500.ms,
                            delay: 150.ms),
                  ),
                  const SizedBox(height: KoSpacing.xxl),
                  strip,
                  const SizedBox(height: KoSpacing.s),
                  Text(l10n.reelFrames(reel.frames.length),
                      style: KoText.bodySmall.copyWith(color: KoColor.textDim)),
                  const Spacer(),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: KoSpacing.xs),
                    child: KoButton(
                        key: const Key('reel-start'),
                        label: l10n.reelStart,
                        onPressed: starting
                            ? null
                            : () => vm.start(reduceMotion: reduceMotion)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _maybeAnimate(
          bool motion, Widget child, Widget Function(Widget) animate) =>
      motion ? animate(child) : child;
}
