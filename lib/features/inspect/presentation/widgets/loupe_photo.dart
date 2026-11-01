import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/theme.dart';
import '../../../content/domain/entities/photo_spec.dart';

/// Üstünde parmakla gezdirilen büyüteç olan fotoğraf.
///
/// Büyüteç parmağın biraz üstünde durur (parmak görüntüyü kapatmasın), ama
/// büyüttüğü nokta parmağın tam altıdır. Her harekette [onProbe] SVG
/// koordinatıyla (300×400) çağrılır; büyütecin yeri ([loupe]) ve ayrıntı bulma
/// kararı view model'dedir. Bu widget durumsuzdur.
class LoupePhoto extends StatelessWidget {
  const LoupePhoto({
    super.key,
    required this.spec,
    required this.width,
    required this.onProbe,
    this.loupe,
    this.highlight = false,
    this.marks = const [],
    this.pulseMarks = false,
    this.zoom = 3,
    this.loupeRadius = 62,
    this.liftAbove = 84,
    this.semanticLabel,
  });

  final PhotoSpec spec;
  final double width;
  final ValueChanged<Offset> onProbe;

  /// Büyütecin baktığı nokta (SVG koordinatı). null: henüz dokunulmadı.
  final Offset? loupe;

  /// Ayrıntı bulunduysa büyüteç çerçevesi kehribar yanar.
  final bool highlight;

  /// Fotoğraf üstünde kehribar halkayla gösterilen ayrıntılar.
  final List<Hotspot> marks;

  /// true: halkalar yavaşça yanıp söner (takılan oyuncuya yol gösterir).
  final bool pulseMarks;
  final double zoom;
  final double loupeRadius;
  final double liftAbove;
  final String? semanticLabel;

  /// Testlerde fotoğraf alanını bulmak için.
  static const photoKey = Key('inspect-photo');
  static const loupeKey = Key('inspect-loupe');

  double get _height =>
      width * PhotoSpec.canvas.height / PhotoSpec.canvas.width;

  /// Ekrandaki nokta ↔ SVG koordinatı.
  double get _scale => PhotoSpec.canvas.width / width;

  void _move(Offset local) {
    final p = Offset(local.dx.clamp(0.0, width), local.dy.clamp(0.0, _height));
    onProbe(p * _scale);
  }

  @override
  Widget build(BuildContext context) {
    final w = width, h = _height;
    final finger = loupe == null ? null : loupe! / _scale;
    final frame = w * 0.033;
    final photo = SvgPicture.asset(
      spec.asset,
      fit: BoxFit.fill,
      excludeFromSemantics: true,
      placeholderBuilder: (_) => const ColoredBox(color: KoColor.surface2),
    );

    return Container(
      padding: EdgeInsets.all(frame),
      decoration: const BoxDecoration(
        color: KoColor.photoFrame,
        boxShadow: [
          BoxShadow(
              color: Color(0x99000000), blurRadius: 30, offset: Offset(0, 16))
        ],
      ),
      child: Semantics(
        image: true,
        label: semanticLabel,
        child: GestureDetector(
          key: LoupePhoto.photoKey,
          behavior: HitTestBehavior.opaque,
          onPanStart: (d) => _move(d.localPosition),
          onPanUpdate: (d) => _move(d.localPosition),
          onTapDown: (d) => _move(d.localPosition),
          child: SizedBox(
            width: w,
            height: h,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(child: photo),
                for (final m in marks) _mark(m, w),
                if (finger != null) ..._loupe(finger, w, h, photo),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _mark(Hotspot m, double w) {
    final k = w / PhotoSpec.canvas.width;
    final r = m.radius * k;
    Widget ring = Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: KoColor.amber.withValues(alpha: 0.12),
        border: Border.all(color: KoColor.amber, width: 2),
      ),
    );
    ring = pulseMarks
        ? ring
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .fade(begin: 0.15, end: 0.9, duration: 1100.ms)
        : ring.animate().fadeIn(duration: 500.ms).scale(
            begin: const Offset(1.3, 1.3),
            end: const Offset(1, 1),
            duration: 500.ms);
    return Positioned(
      key: ValueKey('mark-${m.id}'),
      left: m.center.dx * k - r,
      top: m.center.dy * k - r,
      width: r * 2,
      height: r * 2,
      child: IgnorePointer(child: ring),
    );
  }

  List<Widget> _loupe(Offset f, double w, double h, Widget photo) {
    final r = loupeRadius, z = zoom;
    // Büyütecin ekrandaki merkezi: parmağın üstü (yukarıda yer yoksa altı).
    final cy =
        f.dy - liftAbove >= -r * 0.6 ? f.dy - liftAbove : f.dy + liftAbove;
    final center = Offset(f.dx, cy);
    final ring = highlight ? KoColor.amber : KoColor.paperLineThick;

    return [
      // Parmağın altındaki hedef noktası
      Positioned(
        left: f.dx - 5,
        top: f.dy - 5,
        child: IgnorePointer(
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: ring, width: 1.5)),
          ),
        ),
      ),
      Positioned(
        key: LoupePhoto.loupeKey,
        left: center.dx - r,
        top: center.dy - r,
        width: r * 2,
        height: r * 2,
        child: IgnorePointer(
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: ring, width: highlight ? 4 : 3),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x99000000),
                    blurRadius: 18,
                    offset: Offset(0, 8))
              ],
            ),
            child: ClipOval(
              child: Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  const Positioned.fill(child: ColoredBox(color: KoColor.ink)),
                  // Büyütülmüş fotoğraf: parmağın altındaki nokta büyütecin merkezine gelir.
                  Positioned(
                    left: r - f.dx * z,
                    top: r - f.dy * z,
                    width: w * z,
                    height: h * z,
                    child: photo,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ];
  }
}
