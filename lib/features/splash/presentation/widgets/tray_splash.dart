import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'splash_camera.dart';
import 'splash_title.dart';

/// Banyo tepsisi sahnesi: kırmızı ışık yavaşça yayılır → yukarıdan bir damla düşer,
/// sıvıda halkalar yayılır → dalgaların içinden ters renkli bir negatif belirir →
/// negatif banyo edilir gibi fotoğrafa döner (piksel makine) → "KARANLIK ODA".
/// Zamanı dışarıdan alır ([t], 0–1); kendisi durumsuzdur.
class TraySplash extends StatelessWidget {
  const TraySplash({super.key, required this.t});
  final double t;

  // ---- Zaman çizelgesi (0–1)
  static const _lightEnd = 0.2;
  static const _dropStart = 0.12;
  static const _impact = 0.26;
  static const _negStart = 0.3;
  static const _negEnd = 0.46;
  static const _devStart = 0.5;
  static const _devEnd = 0.74;
  static const _titleStart = 0.68;
  static const _titleEnd = 0.86;
  static const _outStart = 0.9;

  double _phase(double a, double b) => ((t - a) / (b - a)).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    final out = Curves.easeIn.transform(_phase(_outStart, 1));
    return Opacity(
      opacity: 1 - out,
      child: ColoredBox(
        color: const Color(0xFF0A0807),
        child: SizedBox.expand(
          child: CustomPaint(
            painter: _TrayPainter(
              light: Curves.easeOut.transform(_phase(0, _lightEnd)),
              drop: _phase(_dropStart, _impact),
              ripple: _phase(_impact, _impact + 0.5),
              negative: Curves.easeOut.transform(_phase(_negStart, _negEnd)),
              develop: Curves.easeInOut.transform(_phase(_devStart, _devEnd)),
              t: t,
              showDrop: true,
            ),
            child: Align(
              alignment: const Alignment(0, 0.5),
              child: SplashTitle(
                title: Curves.easeOutCubic
                    .transform(_phase(_titleStart, _titleEnd)),
                tagline: Curves.easeOut
                    .transform(_phase(_titleEnd - 0.06, _titleEnd + 0.08)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TrayPainter extends CustomPainter {
  _TrayPainter({
    required this.light,
    required this.drop,
    required this.ripple,
    required this.negative,
    required this.develop,
    required this.t,
    required this.showDrop,
  });

  final double light; // 0–1 kırmızı ışık
  final double drop; // 0–1 damlanın düşüşü
  final double ripple; // 0–1 halkaların yayılması
  final double negative; // 0–1 negatifin belirmesi
  final double develop; // 0–1 negatiften fotoğrafa
  final double t;
  final bool showDrop;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final center = Offset(w / 2, h * 0.38);

    // Kırmızı güvenlik ışığı: yavaşça yayılır.
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFE0503F).withValues(alpha: 0.30 * light),
            const Color(0xFF4A140E).withValues(alpha: 0.22 * light),
            const Color(0x00000000),
          ],
          stops: const [0, 0.5, 1],
        ).createShader(
            Rect.fromCircle(center: Offset(w / 2, h * 0.3), radius: h * 0.75)),
    );

    // Banyo tepsisi (yukarıdan): koyu sıvı, kenarı ışıkta parlıyor.
    final trayW = math.min(w * 0.82, 360.0), trayH = trayW * 0.82;
    final tray = RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: trayW, height: trayH),
        const Radius.circular(16));
    canvas.drawRRect(
        tray,
        Paint()
          ..color = Color.lerp(
              const Color(0xFF0A0807), const Color(0xFF1A100D), light)!);
    canvas.drawRRect(
      tray,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..color = const Color(0xFF6A2A20).withValues(alpha: 0.9 * light),
    );
    canvas.drawRRect(
      tray.deflate(5),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = const Color(0xFFE0503F).withValues(alpha: 0.25 * light),
    );

    canvas.save();
    canvas.clipRRect(tray.deflate(4));

    // Sıvının altındaki fotoğraf: önce negatif (ters renk), sonra pozitif.
    if (negative > 0) {
      final photoW = trayW * 0.62, photoH = photoW * 0.78;
      // Su altında hafif dalgalanma: banyo ilerledikçe durulur.
      final wobble = (1 - develop) * 3.0;
      final photo = Rect.fromCenter(
        center: center +
            Offset(math.sin(t * 18) * wobble, math.cos(t * 15) * wobble * 0.6),
        width: photoW,
        height: photoH,
      );
      // Negatifte kâğıt açık, makine koyu; pozitifte kâğıt koyu, makine krem.
      final paper = Color.lerp(
          const Color(0xFFD8CBB2), const Color(0xFF241A16), develop)!;
      final ink = Color.lerp(
          const Color(0xFF1C1714), const Color(0xFFEFE5D2), develop)!;
      final a = negative;
      canvas.drawRect(photo, Paint()..color = paper.withValues(alpha: a));
      canvas.drawRect(
        photo,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..color = const Color(0xFFEADFCB)
              .withValues(alpha: a * (0.4 + 0.6 * develop)),
      );

      const rows = kSplashCamera;
      final cols = rows.first.length, n = rows.length;
      final cell = math.min(photoW * 0.7 / cols, photoH * 0.7 / n);
      final origin = photo.center - Offset(cell * cols / 2, cell * n / 2);
      final inkPaint = Paint()..color = ink.withValues(alpha: a);
      for (var r = 0; r < n; r++) {
        for (var c = 0; c < cols; c++) {
          if (rows[r][c] != '#') continue;
          // Banyoda kareler birleşip düzgün bir şekle döner.
          final inset = cell * 0.1 * (1 - develop);
          canvas.drawRect(
              Rect.fromLTWH(
                  origin.dx + c * cell + inset,
                  origin.dy + r * cell + inset,
                  cell - inset * 2 + 0.5,
                  cell - inset * 2 + 0.5),
              inkPaint);
        }
      }

      // Pozitifte kırmızı ışık fotoğrafın üstüne vurur.
      if (develop > 0) {
        canvas.drawRect(
          photo,
          Paint()
            ..color = const Color(0xFFE0503F).withValues(alpha: 0.14 * develop)
            ..blendMode = BlendMode.plus,
        );
      }
    }

    // Halkalar: damlanın değdiği yerden yayılır, söner.
    if (ripple > 0 && ripple < 1) {
      for (var k = 0; k < 3; k++) {
        final p = (ripple * 1.3 - k * 0.15).clamp(0.0, 1.0);
        if (p <= 0) continue;
        final radius = trayW * 0.7 * Curves.easeOut.transform(p);
        canvas.drawCircle(
          center,
          radius,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.2 * (1 - p) + 0.5
            ..color = const Color(0xFFF1E8D6).withValues(alpha: 0.45 * (1 - p)),
        );
      }
    }

    // Sıvı yüzeyindeki yansıma: üstte yavaşça kayan hafif bir parıltı.
    final sheen = Rect.fromCenter(
        center: center + Offset(-trayW * 0.15 + t * trayW * 0.3, -trayH * 0.25),
        width: trayW * 0.6,
        height: trayH * 0.18);
    canvas.drawOval(
      sheen,
      Paint()
        ..color = const Color(0xFFF1E8D6).withValues(alpha: 0.05 * light)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16),
    );
    canvas.restore();

    // Damla: yukarıdan hızlanarak düşer, uzar.
    if (showDrop && drop > 0 && drop < 1) {
      final y = -20 + (center.dy + 20) * Curves.easeIn.transform(drop);
      final stretch = 1 + 1.6 * drop;
      canvas.drawOval(
        Rect.fromCenter(
            center: Offset(center.dx, y), width: 7, height: 7 * stretch),
        Paint()..color = const Color(0xFFF1E8D6).withValues(alpha: 0.85),
      );
      canvas.drawOval(
        Rect.fromCenter(
            center: Offset(center.dx, y), width: 16, height: 16 * stretch),
        Paint()
          ..color = const Color(0xFFE0503F).withValues(alpha: 0.25)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );
    }
  }

  @override
  bool shouldRepaint(_TrayPainter old) => true;
}
