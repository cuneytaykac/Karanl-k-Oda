import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/ko_photo.dart';
import '../../../../l10n/l10n.dart';
import '../view_model/develop_view_model.dart';
import '../widgets/develop_tray.dart';
import '../widgets/safelight_matrix.dart';

/// 22 · Banyo: kırmızı ışık altında fotoğraf tepside yavaşça belirir.
///
/// İlerleme (0–1) [DevelopViewModel]'den gelir:
///   0.00–0.80  kâğıt beyazdan görüntüye: görüntü kırmızı ışık altında belirir
///   0.80–1.00  "ışık yanar": kırmızı ton kalkar, gerçek renkler gelir
/// Ekrana dokunmak kalanı hızlandırır (Atla düğmesi yok: dokunmak yeterince hızlı).
class DevelopScreen extends ConsumerWidget {
  const DevelopScreen({
    super.key,
    required this.photoAsset,
    required this.onFinished,
  });

  final String photoAsset;
  final VoidCallback onFinished;

  static const _lightsOnAt = 0.8;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final provider = developViewModelProvider(reduceMotion);
    final state = ref.watch(provider);
    final vm = ref.read(provider.notifier);
    ref.listen(provider.select((s) => s.finished), (_, finished) {
      if (finished) onFinished();
    });

    final l10n = context.l10n;
    final width = MediaQuery.sizeOf(context).width;
    final photoW = (width * 0.62).clamp(200.0, 280.0);

    return Scaffold(
      backgroundColor: KoColor.backgroundDark,
      body: GestureDetector(
        key: const Key('develop-tap-area'),
        behavior: HitTestBehavior.opaque,
        onTap: vm.speedUp,
        child: Builder(
          builder: (context) {
            final t = state.progress;
            final develop =
                Curves.easeIn.transform((t / _lightsOnAt).clamp(0.0, 1.0));
            final lightsOn = Curves.easeInOut.transform(
                ((t - _lightsOnAt) / (1 - _lightsOnAt)).clamp(0.0, 1.0));

            return Stack(
              children: [
                // Güvenlik ışığı: ışık yanınca söner.
                Positioned(
                  top: -120,
                  left: 0,
                  right: 0,
                  child: IgnorePointer(
                    child: Center(
                      child: Opacity(
                        opacity: 1 - lightsOn * 0.7,
                        child: const SizedBox.square(
                          dimension: 320,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(colors: [
                                Color(0x8CE0503F),
                                Color(0x00E0503F)
                              ], stops: [
                                0,
                                0.7
                              ]),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                            KoSpacing.l, KoSpacing.l, KoSpacing.l, 0),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.lerp(KoColor.safelight,
                                    KoColor.textDisabled, lightsOn),
                                boxShadow: [
                                  BoxShadow(
                                      color: KoColor.safelight.withValues(
                                          alpha: 0.6 * (1 - lightsOn)),
                                      blurRadius: 18,
                                      spreadRadius: 6),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Semantics(
                        image: true,
                        label: l10n.developingSemantics,
                        child: DevelopTray(
                          child: Transform.rotate(
                            angle: -0.035,
                            child: Stack(
                              children: [
                                ColorFiltered(
                                  colorFilter: ColorFilter.matrix(
                                      safelightMatrix(1 - lightsOn)),
                                  child: Opacity(
                                    opacity: develop,
                                    child: KoPhoto(
                                        asset: photoAsset, width: photoW),
                                  ),
                                ),
                                // Boş fotoğraf kâğıdı: görüntü belirdikçe silinir.
                                Positioned.fill(
                                  child: IgnorePointer(
                                    child: Opacity(
                                      opacity: (1 - develop) * 0.85,
                                      child: ColoredBox(
                                          color: Color.lerp(
                                              KoColor.photoFrame,
                                              const Color(0xFFE9B9A8),
                                              1 - lightsOn)!),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: KoSpacing.xxxl),
                      SizedBox(
                        width: 200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(
                            key: const Key('develop-progress'),
                            value: t,
                            minHeight: 4,
                            backgroundColor: KoColor.line,
                            color: KoColor.safelight,
                          ),
                        ),
                      ),
                      const SizedBox(height: KoSpacing.m),
                      Text(
                          t < 1 ? l10n.developingProgress : l10n.developingDone,
                          style:
                              KoText.body.copyWith(color: KoColor.textMuted)),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: KoSpacing.xxl),
                        child: Text(l10n.developingTapToSpeed,
                            style: KoText.bodySmall
                                .copyWith(color: KoColor.textDisabled)),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
