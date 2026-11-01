import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/theme.dart';

/// Film şeridi: dişli delikleri, kenarda turuncu kare numaraları, hafif eğik.
/// Banyo edilmiş kareler küçük fotoğraf, sıradaki kare kırmızı çerçeveli, kalanı karanlık.
///
/// Hareket:
/// - [entrance]: kareler soldan sağa sırayla belirir; en son banyo edilen fotoğraf
///   karanlıktan yavaşça çıkar (bir kez oynar).
/// - [live]: kırmızı ışık birkaç saniyede bir şeridin üstünden geçer ve sıradaki kare
///   nefes alır (sürekli). Ana ekranlarda kapalı tutulur.
/// Telefonda "hareketi azalt" açıksa ikisi de oynamaz.
class FilmStrip extends StatelessWidget {
  const FilmStrip({
    super.key,
    required this.count,
    this.current,
    this.photos = const {},
    this.height = 96,
    this.tilt = -0.03,
    this.semanticLabel,
    this.entrance = false,
    this.live = false,
    this.entranceDelay = Duration.zero,
  });

  /// Kare sayısı (genelde 10).
  final int count;

  /// Sıradaki kare (0'dan başlar); yoksa null.
  final int? current;

  /// Banyo edilmiş kareler: sıra → fotoğraf (SVG).
  final Map<int, String> photos;

  final double height;

  /// Radyan. Hafif eğiklik masada duran bir şerit hissi verir.
  final double tilt;
  final String? semanticLabel;

  final bool entrance;
  final bool live;
  final Duration entranceDelay;

  /// Kare başına gecikme ve en son fotoğrafın banyo süresi.
  static const _stagger = 70;
  static const _frameFade = 350;
  static const _developMs = 1400;

  Duration get _introDuration =>
      Duration(milliseconds: _stagger * count + _frameFade + _developMs);

  /// Işık geçişi 4,5 sn'de, nefes 1,6 sn'de bir; ikisinin ortak döngüsü 144 sn.
  static const _sweepMs = 4500, _pulseMs = 1600, _loopMs = 144000;

  @override
  Widget build(BuildContext context) {
    final motion = !(MediaQuery.maybeDisableAnimationsOf(context) ?? false);
    final animateIntro = entrance && motion;
    final animateLive = live && motion;

    Widget strip(double intro) {
      if (!animateLive) return _strip(intro, -1, null);
      return const SizedBox.shrink().animate(onPlay: (c) => c.repeat()).custom(
            duration: const Duration(milliseconds: _loopMs),
            builder: (context, t, _) {
              final ms = t * _loopMs;
              final sweep = (ms % _sweepMs) / _sweepMs;
              // Nefes: 0 → 1 → 0 (ileri-geri).
              final p = (ms % (2 * _pulseMs)) / _pulseMs;
              final pulse = p <= 1 ? p : 2 - p;
              // Işık döngünün ilk %40'ında geçer, kalanı bekler.
              return _strip(intro, sweep / 0.4, pulse);
            },
          );
    }

    final content = animateIntro
        ? const SizedBox.shrink().animate().custom(
              delay: entranceDelay,
              duration: _introDuration,
              builder: (context, intro, _) => strip(intro),
            )
        : strip(1);

    return Semantics(
      label: semanticLabel,
      child: SizedBox(height: height, child: content),
    );
  }

  /// [i]. karenin görünürlüğü (0–1), girişte sırayla.
  double _frameReveal(int i, double intro) {
    if (!entrance) return 1;
    final ms = intro * _introDuration.inMilliseconds;
    return ((ms - _stagger * i) / _frameFade).clamp(0.0, 1.0);
  }

  /// En son banyo edilen fotoğrafın banyo ilerlemesi (0 karanlık → 1 net).
  double _develop(double intro) {
    if (!entrance) return 1;
    final ms = intro * _introDuration.inMilliseconds;
    final start = _stagger * count + _frameFade * 0.5;
    return Curves.easeInOut
        .transform(((ms - start) / _developMs).clamp(0.0, 1.0));
  }

  /// Şeridin bir anı. [sweepT] 0–1 arası ışık geçişi (değilse görünmez);
  /// [pulse] sıradaki karenin nefesi (null: sabit).
  Widget _strip(double intro, double sweepT, double? pulse) {
    final newest = photos.isEmpty ? null : photos.keys.reduce(math.max);
    return LayoutBuilder(builder: (context, c) {
      final g = _Geometry(c.maxWidth, height, count);
      final reveal = [for (var i = 0; i < count; i++) _frameReveal(i, intro)];
      final cur = current;
      return Transform.rotate(
        angle: tilt,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
                child: CustomPaint(
                    painter: _StripPainter(g, cur, reveal, sweepT))),
            for (final e in photos.entries)
              if (e.key >= 0 && e.key < count)
                Positioned(
                  left: g.frameLeft(e.key),
                  top: g.frameTop,
                  width: g.frameW,
                  height: g.frameH,
                  child: Opacity(
                    opacity: reveal[e.key],
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          SvgPicture.asset(
                            e.value,
                            fit: BoxFit.cover,
                            excludeFromSemantics: true,
                            placeholderBuilder: (_) =>
                                const ColoredBox(color: KoColor.completed),
                          ),
                          // En son banyo edilen: karanlıktan yavaşça çıkar.
                          if (e.key == newest && entrance)
                            ColoredBox(
                                color: const Color(0xFF1B110E)
                                    .withValues(alpha: 1 - _develop(intro))),
                        ],
                      ),
                    ),
                  ),
                ),
            // Sıradaki karenin çerçevesi; canlıysa nefes alır.
            if (cur != null && cur >= 0 && cur < count)
              Positioned(
                left: g.frameLeft(cur) - 2,
                top: g.frameTop - 2,
                width: g.frameW + 4,
                height: g.frameH + 4,
                child: IgnorePointer(
                  child: Opacity(
                    opacity: reveal[cur],
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        border:
                            Border.all(color: KoColor.safelight, width: 2.5),
                        boxShadow: [
                          BoxShadow(
                            color: KoColor.safelight.withValues(
                              alpha: pulse != null
                                  ? 0.25 +
                                      0.45 * Curves.easeInOut.transform(pulse)
                                  : 0.4,
                            ),
                            blurRadius: pulse != null ? 8 + 10 * pulse : 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}

/// Şeridin ölçüleri: genişliğe göre 10 kare sığacak şekilde hesaplanır.
class _Geometry {
  _Geometry(this.width, this.height, this.count) : pitch = width / count;

  final double width;
  final double height;
  final int count;
  final double pitch;

  double get frameW => pitch * 0.82;
  double get frameH => height * 0.54;
  double get frameTop => height * 0.15;
  double frameLeft(int i) => i * pitch + (pitch - frameW) / 2;

  double get holeH => height * 0.065;
  double get holeTopY => height * 0.04;
  double get holeBottomY => height * 0.72;

  /// Kare numaraları: alt deliklerin altında, şeridin içinde kalacak boyda.
  double get numberSize => (height * 0.12).clamp(8.0, 11.0);
  double get numberTop => height * 0.81;
}

class _StripPainter extends CustomPainter {
  _StripPainter(this.g, this.current, this.reveal, this.sweep);
  final _Geometry g;
  final int? current;

  /// Her karenin görünürlüğü (0–1).
  final List<double> reveal;

  /// Kırmızı ışığın konumu: 0 sol uç, 1 sağ uç; dışındaysa ışık yok.
  final double sweep;

  static const _band = Color(0xFF141010);
  static const _hole = Color(0xFF0A0807);
  static const _frame = Color(0xFF2A1A15);
  static const _frameEdge = Color(0xFF3A2620);
  static const _number = Color(0xFFE8893A);

  @override
  void paint(Canvas canvas, Size size) {
    // Şerit kenarlardan biraz taşar (makaradan çıkıp gidiyormuş gibi).
    const overhang = 24.0;
    final band =
        Rect.fromLTWH(-overhang, 0, size.width + overhang * 2, size.height);
    canvas.drawRect(band, Paint()..color = _band);

    // Dişli delikleri: kare başına 2, iki kenarda.
    final holeW = g.pitch * 0.16;
    final holePaint = Paint()..color = _hole;
    for (var x = -overhang + g.pitch * 0.12;
        x < size.width + overhang;
        x += g.pitch / 2) {
      for (final y in [g.holeTopY, g.holeBottomY]) {
        canvas.drawRRect(
            RRect.fromRectAndRadius(Rect.fromLTWH(x, y, holeW, g.holeH),
                const Radius.circular(1.5)),
            holePaint);
      }
    }

    // Kareler (karanlık) ve kenardaki numaralar; girişte sırayla belirir.
    for (var i = 0; i < g.count; i++) {
      final a = reveal[i];
      if (a <= 0) continue;
      final r = RRect.fromRectAndRadius(
          Rect.fromLTWH(g.frameLeft(i), g.frameTop, g.frameW, g.frameH),
          const Radius.circular(2));
      canvas.drawRRect(r, Paint()..color = _frame.withValues(alpha: a));
      canvas.drawRRect(
        r,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = _frameEdge.withValues(alpha: a),
      );
      final tp = TextPainter(
        text: TextSpan(
          text: '${i + 1}',
          style: KoText.counter.copyWith(
            fontSize: g.numberSize,
            height: 1,
            color: _number.withValues(alpha: (i == current ? 1 : 0.7) * a),
          ),
        ),
        textDirection: TextDirection.ltr,
        textScaler: TextScaler.noScaling,
      )..layout();
      tp.paint(canvas,
          Offset(g.frameLeft(i) + g.frameW / 2 - tp.width / 2, g.numberTop));
    }

    // Kırmızı ışık geçişi: şeridin üstünden süzülen yumuşak bir leke.
    if (sweep >= 0 && sweep <= 1) {
      final x = -overhang +
          (size.width + overhang * 2) * Curves.easeInOut.transform(sweep);
      final fade = math.sin(sweep * math.pi); // başta ve sonda söner
      final light = Rect.fromCircle(
          center: Offset(x, size.height / 2), radius: size.height * 0.9);
      canvas.save();
      canvas.clipRect(band);
      canvas.drawRect(
        light,
        Paint()
          ..blendMode = BlendMode.plus
          ..shader = RadialGradient(
            colors: [
              const Color(0xFFE0503F).withValues(alpha: 0.32 * fade),
              const Color(0x00E0503F)
            ],
          ).createShader(light),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_StripPainter old) => true;
}
