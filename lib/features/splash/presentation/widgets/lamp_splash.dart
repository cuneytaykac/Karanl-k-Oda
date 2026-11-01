import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'splash_camera.dart';
import 'splash_title.dart';

/// Lamba sahnesi: karanlık → lamba tıklayıp titreyerek yanar → nonogram ızgarası
/// dalga gibi dolup piksel bir fotoğraf makinesi olur → banyo edilir gibi netleşir,
/// objektifte ışık çakar → "KARANLIK ODA" yerine oturur → uygulamaya geçilir.
/// Zamanı dışarıdan alır ([t], 0–1); kendisi durumsuzdur.
class LampSplash extends StatelessWidget {
  const LampSplash({super.key, required this.t});
  final double t;

  // ---- Zaman çizelgesi (0–1)
  static const _lampStart = 0.08;
  static const _lampEnd = 0.22;
  static const _gridStart = 0.22;
  static const _gridEnd = 0.58;
  static const _developEnd = 0.70;
  static const _flashAt = 0.70;
  static const _titleStart = 0.66;
  static const _titleEnd = 0.84;
  static const _outStart = 0.88;

  double _phase(double a, [double? b]) {
    final end = b ?? a + 0.0001;
    return ((t - a) / (end - a)).clamp(0.0, 1.0);
  }

  /// Lamba parlaklığı: iki kez titreyip sabitlenir.
  double _lamp() {
    final p = _phase(_lampStart, _lampEnd);
    if (p <= 0) return 0;
    if (p < 0.18) return 0.7;
    if (p < 0.3) return 0.08;
    if (p < 0.45) return 0.85;
    if (p < 0.55) return 0.2;
    return 0.2 + 0.8 * Curves.easeOut.transform((p - 0.55) / 0.45);
  }

  @override
  Widget build(BuildContext context) {
    final out = Curves.easeIn.transform(_phase(_outStart, 1));
    return Opacity(
      opacity: 1 - out,
      child: ColoredBox(
        color: const Color(0xFF0A0807),
        child: SizedBox.expand(
          child: CustomPaint(
            painter: _SplashPainter(
              lamp: _lamp(),
              grid: _phase(_gridStart, _gridEnd),
              develop: Curves.easeInOut
                  .transform(_phase(_gridEnd - 0.04, _developEnd)),
              flash: _phase(_flashAt, _flashAt + 0.08),
              t: t,
              wave: true,
            ),
            child: Align(
              alignment: const Alignment(0, 0.42),
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

class _SplashPainter extends CustomPainter {
  _SplashPainter(
      {required this.lamp,
      required this.grid,
      required this.develop,
      required this.flash,
      required this.t,
      required this.wave});

  /// 0–1 lamba parlaklığı.
  final double lamp;

  /// 0–1 ızgaranın dolması.
  final double grid;

  /// 0–1 banyo: ızgara çizgileri söner, makine kırmızı ışıkta netleşir.
  final double develop;

  /// 0–1 objektifte ışık çakması.
  final double flash;

  /// Genel zaman (toz zerreleri için).
  final double t;

  /// Tam sürümde kareler köşeden dalga gibi dolar.
  final bool wave;

  static final _dust = List.generate(26, (i) {
    final r = math.Random(i * 7919);
    return (
      r.nextDouble(),
      r.nextDouble(),
      0.6 + r.nextDouble() * 1.6,
      r.nextDouble()
    );
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;

    // Lambanın ışığı: yukarıdan yayılan kırmızı.
    if (lamp > 0) {
      final light =
          Rect.fromCircle(center: Offset(w / 2, -h * 0.05), radius: h * 0.95);
      canvas.drawRect(
        Offset.zero & size,
        Paint()
          ..shader = RadialGradient(
            colors: [
              const Color(0xFFE0503F).withValues(alpha: 0.42 * lamp),
              const Color(0xFF5A1A12).withValues(alpha: 0.28 * lamp),
              const Color(0x00000000),
            ],
            stops: const [0, 0.45, 1],
          ).createShader(light),
      );
      // Lambanın kendisi: tepede küçük, parlak bir nokta.
      canvas.drawCircle(Offset(w / 2, h * 0.06), 7,
          Paint()..color = const Color(0xFFFF8A70).withValues(alpha: lamp));
      canvas.drawCircle(
        Offset(w / 2, h * 0.06),
        26,
        Paint()
          ..color = const Color(0xFFE0503F).withValues(alpha: 0.35 * lamp)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14),
      );
    }

    // Toz zerreleri: ışıkta görünür, yavaşça süzülür.
    for (final (x0, y0, r, phase) in _dust) {
      final y = ((y0 + t * 0.12 + phase * 0.1) % 1.0) * h;
      final x = (x0 + math.sin((t + phase) * math.pi * 2) * 0.01) * w;
      canvas.drawCircle(
          Offset(x, y),
          r,
          Paint()
            ..color =
                const Color(0xFFF1E8D6).withValues(alpha: 0.08 + 0.18 * lamp));
    }

    // Piksel fotoğraf makinesi: nonogram ızgarası gibi dolar.
    const rows = kSplashCamera;
    final cols = rows.first.length, n = rows.length;
    final cell = math.min(w * 0.62 / cols, 22.0);
    final gw = cell * cols, gh = cell * n;
    final origin = Offset((w - gw) / 2, h * 0.36 - gh / 2);

    if (grid > 0) {
      // Izgara çizgileri (banyoda söner).
      final lineAlpha = 0.22 * (1 - develop) * math.min(1, grid * 4);
      if (lineAlpha > 0) {
        final line = Paint()
          ..strokeWidth = 1
          ..color = const Color(0xFFD2C4AC).withValues(alpha: lineAlpha);
        for (var c = 0; c <= cols; c++) {
          canvas.drawLine(origin + Offset(c * cell, 0),
              origin + Offset(c * cell, gh), line);
        }
        for (var r = 0; r <= n; r++) {
          canvas.drawLine(origin + Offset(0, r * cell),
              origin + Offset(gw, r * cell), line);
        }
      }

      // Kareler: köşeden dalga gibi (tam sürüm) ya da hep birlikte (kısa sürüm).
      final maxD = (cols + n).toDouble();
      final ink = Color.lerp(
          const Color(0xFFEFE5D2), const Color(0xFFF6D7C8), develop * 0.5)!;
      for (var r = 0; r < n; r++) {
        for (var c = 0; c < cols; c++) {
          if (rows[r][c] != '#') continue;
          final local =
              wave ? ((grid * (maxD + 6) - (r + c)) / 6).clamp(0.0, 1.0) : grid;
          if (local <= 0) continue;
          final inset = cell * 0.08 * (1 - develop); // banyoda kareler birleşir
          final s = (cell - inset * 2) *
              (0.6 + 0.4 * Curves.easeOutBack.transform(local));
          final center =
              origin + Offset(c * cell + cell / 2, r * cell + cell / 2);
          canvas.drawRect(
            Rect.fromCenter(
                center: center,
                width: s + develop * 0.6,
                height: s + develop * 0.6),
            Paint()..color = ink.withValues(alpha: local),
          );
        }
      }

      // Banyo: makine kırmızı ışıkta hafifçe parlar.
      if (develop > 0) {
        canvas.drawRect(
          origin & Size(gw, gh),
          Paint()
            ..color = const Color(0xFFE0503F)
                .withValues(alpha: 0.12 * develop * (1 - flash * 0.5))
            ..blendMode = BlendMode.plus
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18),
        );
      }

      // Objektifte ışık çakması: merkezden kısa bir parıltı ve dört ışın.
      if (flash > 0 && flash < 1) {
        final lens = origin + Offset(cell * 7.5, cell * 7); // merceğin merkezi
        final a = math.sin(flash * math.pi);
        canvas.drawCircle(
          lens,
          cell * (0.6 + 2.4 * flash),
          Paint()
            ..color = const Color(0xFFFFF4E0).withValues(alpha: 0.85 * a)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
        );
        final ray = Paint()
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round
          ..color = const Color(0xFFFFF4E0).withValues(alpha: 0.7 * a);
        final len = cell * (1.5 + 4 * flash);
        for (var k = 0; k < 4; k++) {
          final ang = k * math.pi / 2 + math.pi / 4;
          canvas.drawLine(
              lens, lens + Offset(math.cos(ang), math.sin(ang)) * len, ray);
        }
      }
    }
  }

  @override
  bool shouldRepaint(_SplashPainter old) => true;
}
