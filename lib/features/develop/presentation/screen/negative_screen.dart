import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/ko_button.dart';
import '../../../../l10n/l10n.dart';
import '../../../content/data/datasources/sample_content.dart';
import '../../../puzzle/domain/nonogram/puzzle.dart';
import '../../domain/entities/frame_result.dart';

/// 21 · Kare tamam: çözülen desen film negatifi olarak.
class NegativeScreen extends StatelessWidget {
  const NegativeScreen({
    super.key,
    required this.caseId,
    required this.reel,
    required this.frame,
    required this.onDevelop,
    this.result,
    this.puzzle,
  });

  final String caseId;
  final int reel;
  final int frame;
  final FrameResult? result;
  final VoidCallback onDevelop;

  /// Çözülen bulmaca; verilmezse örnek içerik.
  final Puzzle? puzzle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final puzzle = this.puzzle ?? SamplePuzzles.puzzleFor(caseId, reel, frame);
    final r = result ?? const FrameResult(solveTime: null, hintsUsed: 0);

    return Scaffold(
      body: Stack(
        children: [
          const _Glow(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  KoSpacing.l, KoSpacing.xxxl, KoSpacing.l, KoSpacing.xxl),
              child: Column(
                children: [
                  Text(l10n.negativeEyebrow(reel, frame),
                      style: KoText.label.copyWith(color: KoColor.redText)),
                  const SizedBox(height: KoSpacing.xs),
                  Text(l10n.negativeTitle, style: KoText.screenTitle),
                  const SizedBox(height: KoSpacing.xxl),
                  Expanded(
                    child: Center(
                      child: Semantics(
                        image: true,
                        label: l10n.negativeImageLabel,
                        child: NegativeFilm(
                            key: const Key('negative-film'), puzzle: puzzle),
                      ),
                    ),
                  ),
                  const SizedBox(height: KoSpacing.xxl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _Stat(value: r.timeLabel, label: l10n.statTime),
                      const SizedBox(width: KoSpacing.xxxl),
                      _Stat(value: '${r.hintsUsed}', label: l10n.statHints),
                      const SizedBox(width: KoSpacing.xxxl),
                      _Stat(value: '$frame/10', label: l10n.statFrame),
                    ],
                  ),
                  const SizedBox(height: KoSpacing.l),
                  Text(
                    l10n.negativeHint,
                    style: KoText.body.copyWith(color: KoColor.textMuted),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: KoSpacing.xxl),
                  KoButton(
                      key: const Key('develop-button'),
                      label: l10n.developButton,
                      icon: Icons.water_drop_outlined,
                      onPressed: onDevelop),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Film negatifi: dolu kareler açık renk, zemin koyu kahve.
class NegativeFilm extends StatelessWidget {
  const NegativeFilm({super.key, required this.puzzle, this.maxSize = 260});

  final Puzzle puzzle;
  final double maxSize;

  static const _film = Color(0xFF2A1A15);
  static const _filmEdge = Color(0xFF5A2A22);
  static const _light = Color(0xFFE8DCC6);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final side = [maxSize, c.maxWidth - 28, c.maxHeight - 28]
            .reduce((a, b) => a < b ? a : b);
        final cell = ((side < 60 ? 60.0 : side) / puzzle.width).floorToDouble();
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _film,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: _filmEdge),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x99000000),
                  blurRadius: 40,
                  offset: Offset(0, 20))
            ],
          ),
          child: SizedBox(
            width: cell * puzzle.width,
            height: cell * puzzle.height,
            child: CustomPaint(painter: _NegativePainter(puzzle, cell)),
          ),
        );
      },
    );
  }
}

class _NegativePainter extends CustomPainter {
  _NegativePainter(this.puzzle, this.cell);
  final Puzzle puzzle;
  final double cell;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = NegativeFilm._light;
    for (var r = 0; r < puzzle.height; r++) {
      for (var c = 0; c < puzzle.width; c++) {
        if (puzzle.isFilled(r, c)) {
          canvas.drawRect(Rect.fromLTWH(c * cell, r * cell, cell, cell), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(_NegativePainter old) =>
      old.puzzle != puzzle || old.cell != cell;
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});
  final String value, label;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(value, style: KoText.bigNumber.copyWith(fontSize: 18)),
          Text(label,
              style: KoText.bodySmall
                  .copyWith(color: KoColor.textDim, fontSize: 11.5)),
        ],
      );
}

class _Glow extends StatelessWidget {
  const _Glow();

  @override
  Widget build(BuildContext context) => const Positioned(
        top: 60,
        left: 0,
        right: 0,
        child: IgnorePointer(
          child: Center(
            child: SizedBox.square(
              dimension: 360,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                      colors: [Color(0x40E0503F), Color(0x00E0503F)],
                      stops: [0, 0.7]),
                ),
              ),
            ),
          ),
        ),
      );
}
