import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Kırmızı güvenlik ışığı: nefes alır gibi parlayıp söner (3,2 sn'de bir).
class SafelightGlow extends StatelessWidget {
  const SafelightGlow({super.key, this.motion = true});

  /// false: hareket azaltılmış, ışık sabit durur.
  final bool motion;

  @override
  Widget build(BuildContext context) {
    if (!motion) return _glow(0.5);
    return const SizedBox.shrink()
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .custom(
          duration: 3200.ms,
          curve: Curves.easeInOut,
          builder: (context, t, _) => _glow(t),
        );
  }

  static Widget _glow(double t) => SizedBox.square(
        dimension: 280 + 40 * t,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                const Color(0xFFE0503F).withValues(alpha: 0.18 + 0.16 * t),
                const Color(0x00E0503F),
              ],
              stops: const [0, 0.7],
            ),
          ),
        ),
      );
}
