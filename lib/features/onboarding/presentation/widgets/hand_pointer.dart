import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/theme.dart';

/// Sürükleme hareketini gösteren el: [from]'dan [to]'ya kayar, döngüyle tekrarlar.
/// İki nokta aynıysa dokunma gösterir (bastırıp bırakır). Koordinatlar ızgaraya göredir.
class HandPointer extends StatelessWidget {
  const HandPointer({super.key, required this.from, required this.to});

  final Offset from;
  final Offset to;

  static const _size = 44.0;
  static const _loop = Duration(milliseconds: 2400);

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    // Hareket azaltılmışsa el yolun ortasında durur.
    if (reduceMotion) return _frame(0.5);
    return const SizedBox.expand().animate(onPlay: (c) => c.repeat()).custom(
          duration: _loop,
          builder: (context, t, _) => _frame(t),
        );
  }

  /// Döngünün [t] anındaki el (0–1).
  /// 0–0,15 belir · 0,15–0,7 kay · 0,7–0,85 sön · gerisi bekle.
  Widget _frame(double t) {
    final tap = from == to;
    final opacity = t < 0.15
        ? t / 0.15
        : (t < 0.7 ? 1.0 : (t < 0.85 ? 1 - (t - 0.7) / 0.15 : 0.0));
    final move =
        Curves.easeInOut.transform(((t - 0.15) / 0.55).clamp(0.0, 1.0));
    final pos = Offset.lerp(from, to, move)!;
    // Basılıyken biraz küçülür; dokunmada iki kez bastırır.
    final press = tap
        ? (0.5 + 0.5 * (1 - (2 * ((t * 4) % 1) - 1).abs()))
        : (t > 0.12 && t < 0.72 ? 1.0 : 0.0);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          // İşaret parmağının ucu karenin ortasına gelsin.
          left: pos.dx - _size * 0.38,
          top: pos.dy - _size * 0.12,
          child: Opacity(
            opacity: opacity,
            child: Transform.scale(
              scale: 1 - 0.12 * press,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Parmağın değdiği yerde kırmızı halka.
                  Positioned(
                    left: _size * 0.38 - 10,
                    top: _size * 0.12 - 10,
                    child: Opacity(
                      opacity: press,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: KoColor.safelight.withValues(alpha: 0.35),
                          border:
                              Border.all(color: KoColor.safelight, width: 2),
                        ),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.touch_app_rounded,
                    size: _size,
                    color: KoColor.text,
                    shadows: [
                      Shadow(
                          color: Color(0xCC000000),
                          blurRadius: 8,
                          offset: Offset(0, 2)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
