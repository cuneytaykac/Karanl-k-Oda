import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/theme.dart';

/// Banyo edilmiş bir fotoğraf: krem kâğıt çerçeve içinde 3:4 SVG.
class KoPhoto extends StatelessWidget {
  const KoPhoto(
      {super.key,
      required this.asset,
      this.width = 240,
      this.semanticLabel,
      this.tilt = 0});

  /// Örn. `assets/case_files/wrong_man/photos/r2_k3_lake.svg`
  final String asset;
  final double width;
  final String? semanticLabel;

  /// Hafif eğiklik (radyan). Banyo tepsisinde -0.035 gibi.
  final double tilt;

  @override
  Widget build(BuildContext context) {
    final frame = width * 0.033;
    return Transform.rotate(
      angle: tilt,
      child: Container(
        width: width,
        padding: EdgeInsets.all(frame),
        decoration: const BoxDecoration(
          color: KoColor.photoFrame,
          boxShadow: [
            BoxShadow(
                color: Color(0x99000000), blurRadius: 30, offset: Offset(0, 16))
          ],
        ),
        child: AspectRatio(
          aspectRatio: 3 / 4,
          child: SvgPicture.asset(
            asset,
            fit: BoxFit.cover,
            semanticsLabel: semanticLabel,
            excludeFromSemantics: semanticLabel == null,
            placeholderBuilder: (_) =>
                const ColoredBox(color: KoColor.surface2),
          ),
        ),
      ),
    );
  }
}
