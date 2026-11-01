import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/audio/audio.dart';
import '../../../../core/dev_flags.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/settings/settings.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/ko_icon_button.dart';
import '../../../../l10n/l10n.dart';
import '../../../content/data/datasources/sample_content.dart';
import '../../../develop/domain/entities/frame_result.dart';
import '../../domain/nonogram/cell_state.dart';
import '../view_model/puzzle_view_model.dart';
import '../widgets/nonogram_board.dart';
import '../widgets/puzzle_toolbar.dart';

/// 17 · Bulmaca (oynanabilir).
class PuzzleScreen extends ConsumerWidget {
  const PuzzleScreen(
      {super.key,
      required this.caseId,
      required this.reel,
      required this.frame,
      this.onContinue});

  final String caseId;
  final int reel;
  final int frame;

  /// Çözüldükten sonra "Devam". Verilmezse negatif ekranına geçer (testlerde değiştirilir).
  final void Function(FrameResult result)? onContinue;

  /// Geçici: Aşama 2'de içerikten gelecek.
  static const previewPhoto = SamplePuzzles.fishPhoto;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = (caseId: caseId, reel: reel, frame: frame);
    final view = ref.watch(puzzleViewModelProvider(key));
    final ctrl = ref.read(puzzleViewModelProvider(key).notifier);
    final vibrate = ref.watch(settingsProvider.select((s) => s.vibration));
    final l10n = context.l10n;
    final p = view.puzzle;

    final audio = ref.read(gameAudioProvider);

    void tick(bool changed) {
      if (!changed) return;
      if (vibrate) HapticFeedback.selectionClick();
      audio.play(view.tool == Tool.cross ? Sfx.cross : Sfx.tap);
    }

    // Yeni tamamlanan satır/sütun hafif bir zil; bulmaca çözülünce akor.
    ref.listen<PuzzleState>(puzzleViewModelProvider(key), (prev, next) {
      if (prev == null) return;
      if (next.solved && !prev.solved) {
        audio.play(Sfx.solve);
      } else if (_satisfiedLines(next) > _satisfiedLines(prev)) {
        audio.play(Sfx.line);
      }
    });

    void say(String message) => ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));

    // Hak varsa ipucu; bittiyse reklamla ek ipucu; o da dolduysa kendin çöz.
    Future<void> hint() async {
      if (view.hintsLeft > 0) {
        ctrl.useHint();
      } else if (view.adHintAvailable) {
        final outcome = await ctrl.watchAdForHint();
        if (outcome == AdHintOutcome.dismissed && context.mounted) {
          say(l10n.puzzleAdDismissed);
        }
      } else {
        say(l10n.puzzleNoHints);
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              KoSpacing.l, KoSpacing.m, KoSpacing.l, KoSpacing.l),
          child: Column(
            children: [
              Row(
                children: [
                  KoIconButton(
                      icon: Icons.chevron_left,
                      label: l10n.puzzleBackLabel,
                      onPressed: () => context.pop()),
                  Expanded(
                    child: Column(
                      children: [
                        Text(l10n.puzzleTitle(reel, frame),
                            style: KoText.cardTitle,
                            textAlign: TextAlign.center),
                        Text('${p.width}×${p.height}', style: KoText.counter),
                      ],
                    ),
                  ),
                  // GELİŞTİRME: bulmacayı anında çözer (dev_flags.dart).
                  if (kDevSkipButton && !view.solved)
                    KoIconButton(
                        key: const Key('dev-skip'),
                        icon: Icons.fast_forward_rounded,
                        label: 'Atla',
                        onPressed: ctrl.devSkip)
                  else
                    const SizedBox(width: KoSize.iconButton),
                ],
              ),
              const SizedBox(height: KoSpacing.l),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: NonogramBoard(
                      board: view.board,
                      showMistakes: view.showMistakes,
                      activeRow: view.activeRow,
                      activeCol: view.activeCol,
                      semanticLabel: l10n.puzzleGridLabel(p.width, p.height),
                      onStrokeStart: (id, r, c) =>
                          tick(ctrl.touchDown(id, r, c)),
                      onStrokeExtend: (id, r, c) =>
                          tick(ctrl.touchMove(id, r, c)),
                      onStrokeEnd: ctrl.touchUp,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: KoSpacing.m),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: view.solved
                    ? _SolvedCard(
                        key: const ValueKey('solved'),
                        title: l10n.puzzleSolvedTitle,
                        body: l10n.puzzleSolvedBody,
                        action: l10n.puzzleContinue,
                        onAction: () {
                          final result = FrameResult(
                              solveTime: view.solveTime,
                              hintsUsed: view.hintsUsed);
                          if (onContinue != null) {
                            onContinue!(result);
                          } else {
                            context.pushReplacement(
                                Routes.negative(caseId, reel, frame),
                                extra: result);
                          }
                        },
                      )
                    : Padding(
                        key: const ValueKey('help'),
                        padding: const EdgeInsets.only(bottom: KoSpacing.m),
                        child: Text(l10n.puzzleHelp,
                            style: KoText.bodySmall,
                            textAlign: TextAlign.center),
                      ),
              ),
              if (!view.solved)
                PuzzleToolbar(
                  tool: view.tool,
                  onTool: ctrl.setTool,
                  fillLabel: l10n.puzzleToolFill,
                  crossLabel: l10n.puzzleToolCross,
                  undoLabel: l10n.puzzleUndo,
                  hintLabel: view.hintsLeft == 0 && view.adHintAvailable
                      ? l10n.puzzleHintAd
                      : l10n.puzzleHint(view.hintsLeft),
                  hintIcon: view.hintsLeft == 0 && view.adHintAvailable
                      ? Icons.smart_display_outlined
                      : Icons.lightbulb_outline_rounded,
                  hintAccent: view.hintsLeft > 0 || view.adHintAvailable,
                  clearLabel: l10n.puzzleClear,
                  onUndo: view.canUndo ? ctrl.undo : null,
                  onHint: view.adLoading ? null : hint,
                  onClear: view.board.cells.any((c) => c != CellState.empty)
                      ? ctrl.clear
                      : null,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SolvedCard extends StatelessWidget {
  const _SolvedCard(
      {super.key,
      required this.title,
      required this.body,
      required this.action,
      required this.onAction});

  final String title, body, action;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
          KoSpacing.l, KoSpacing.m, KoSpacing.m, KoSpacing.m),
      decoration: BoxDecoration(
        color: KoColor.surface,
        borderRadius: BorderRadius.circular(KoRadius.card),
        border: Border.all(color: KoColor.safelight),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: KoText.cardTitle.copyWith(fontSize: 16)),
                Text(body, style: KoText.bodySmall),
              ],
            ),
          ),
          FilledButton(
            onPressed: onAction,
            style: FilledButton.styleFrom(
              backgroundColor: KoColor.redButton,
              foregroundColor: KoColor.redButtonText,
              minimumSize: const Size(0, 44),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(KoRadius.medium)),
            ),
            child: Text(action,
                style:
                    KoText.buttonSmall.copyWith(color: KoColor.redButtonText)),
          ),
        ],
      ),
    );
  }
}

/// Doğru tamamlanmış satır + sütun sayısı (boş ipuçlu satırlar hariç: onlar baştan "tamam"dır).
int _satisfiedLines(PuzzleState v) {
  final b = v.board, p = v.puzzle;
  var n = 0;
  for (var r = 0; r < p.height; r++) {
    if (p.rowClues[r].isNotEmpty && b.isRowSatisfied(r)) n++;
  }
  for (var c = 0; c < p.width; c++) {
    if (p.colClues[c].isNotEmpty && b.isColSatisfied(c)) n++;
  }
  return n;
}
