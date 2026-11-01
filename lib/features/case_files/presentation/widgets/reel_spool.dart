import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/theme.dart';

/// Film makarası: dış çember, içi sarılı film (koyu kırmızı halka), dört kol ve göbek.
/// Kolların ve göbek deliklerinin dönmesi makaranın döndüğünü belli eder.
class ReelSpool extends StatelessWidget {
  const ReelSpool({super.key, required this.winding, this.motion = true});

  /// true: başlarken hızlı 2,5 tur (hızlanarak).
  final bool winding;

  /// false: hareket azaltılmış, makara durur.
  final bool motion;

  @override
  Widget build(BuildContext context) {
    if (!motion) return _spool(0);
    return const SizedBox.shrink()
        // Boşta yavaş tur: 12 sn'de bir.
        .animate(onPlay: (c) => c.repeat())
        .custom(
          duration: 12.seconds,
          builder: (context, idle, _) => TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: winding ? 1 : 0),
            duration: const Duration(milliseconds: 650),
            curve: Curves.easeIn,
            builder: (context, wind, _) =>
                _spool(2 * math.pi * (idle + 2.5 * wind)),
          ),
        );
  }

  static Widget _spool(double angle) => SizedBox.square(
        dimension: 150,
        child: CustomPaint(painter: _SpoolPainter(angle)),
      );
}

class _SpoolPainter extends CustomPainter {
  const _SpoolPainter(this.angle);
  final double angle;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.shortestSide / 2;

    // Makaradan sarkan film ucu (dönmez).
    final tail = Path()
      ..moveTo(c.dx + r * 0.62, c.dy + r * 0.1)
      ..quadraticBezierTo(
          c.dx + r * 1.05, c.dy + r * 0.2, c.dx + r * 1.0, c.dy + r * 0.95);
    canvas.drawPath(
      tail,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.16
        ..strokeCap = StrokeCap.butt
        ..color = const Color(0xFF2A1A15),
    );

    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(angle);

    canvas.drawCircle(
        Offset.zero, r * 0.88, Paint()..color = const Color(0xFF1E1A17));
    canvas.drawCircle(
      Offset.zero,
      r * 0.88,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = const Color(0xFF3A302A),
    );
    // Sarılı film.
    canvas.drawCircle(
      Offset.zero,
      r * 0.6,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.2
        ..color = const Color(0xFF5A2A22),
    );
    // Filmin katmanları (ince halkalar dönüşü belli eder).
    final layer = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..color = const Color(0x55000000);
    for (final k in const [0.53, 0.58, 0.64]) {
      canvas.drawArc(Rect.fromCircle(center: Offset.zero, radius: r * k), 0.3,
          4.6, false, layer);
    }
    // Kollar.
    final spoke = Paint()
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFF3A302A);
    for (var i = 0; i < 4; i++) {
      final a = i * math.pi / 2;
      final d = Offset(math.cos(a), math.sin(a));
      canvas.drawLine(d * r * 0.7, d * r * 0.86, spoke);
    }
    // Göbek ve üç delik.
    canvas.drawCircle(
        Offset.zero, r * 0.24, Paint()..color = KoColor.background);
    canvas.drawCircle(
        Offset.zero, r * 0.24, Paint()..color = const Color(0xFF2A221D));
    for (var i = 0; i < 3; i++) {
      final a = i * 2 * math.pi / 3;
      canvas.drawCircle(Offset(math.cos(a), math.sin(a)) * r * 0.13, r * 0.045,
          Paint()..color = KoColor.background);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_SpoolPainter old) => old.angle != angle;
}
