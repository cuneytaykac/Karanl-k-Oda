import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/ko_button.dart';
import '../../../../l10n/l10n.dart';
import '../../../puzzle/presentation/widgets/puzzle_toolbar.dart';
import '../view_model/tutorial_view_model.dart';
import '../widgets/tutorial_board.dart';
import '../widgets/tutorial_note.dart';

/// İlk açılıştaki öğretici. Mantık [TutorialViewModel]'de; bu ekran yalnızca çizer.
class TutorialScreen extends ConsumerWidget {
  const TutorialScreen({super.key, required this.onDone});
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(tutorialViewModelProvider);
    final vm = ref.read(tutorialViewModelProvider.notifier);
    final notes = [
      l10n.tutorialStep1,
      l10n.tutorialStep2,
      l10n.tutorialStep3,
      l10n.tutorialStep4,
    ];

    // Öğreticiden geri dönülmez (telefonun geri hareketi de kapalı).
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(KoSpacing.l),
            child: Column(
              children: [
                Text(l10n.tutorialEyebrow,
                    style: KoText.label.copyWith(color: KoColor.redText)),
                const SizedBox(height: 2),
                Text(l10n.tutorialTitle, style: KoText.screenTitle),
                const SizedBox(height: KoSpacing.l),
                TutorialNote(
                  step: state.step,
                  label: state.done
                      ? l10n.tutorialDoneTitle
                      : l10n.tutorialStepOf(
                          state.step + 1, TutorialViewModel.steps),
                  text: state.done ? l10n.tutorialDoneBody : notes[state.step],
                ),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 300),
                      child: const TutorialBoard(),
                    ),
                  ),
                ),
                if (!state.done)
                  PuzzleToolbar(
                    tool: state.tool,
                    onTool: vm.setTool,
                    fillLabel: l10n.puzzleToolFill,
                    crossLabel: l10n.puzzleToolCross,
                    undoLabel: l10n.puzzleUndo,
                    hintLabel: l10n.puzzleHint(state.hintsLeft),
                    clearLabel: l10n.puzzleClear,
                    onUndo: state.canUndo ? vm.undo : null,
                    onHint: vm.hint,
                    onClear: vm.clear,
                    hintAccent: state.hintsLeft > 0,
                  )
                else
                  KoButton(
                    key: const Key('tutorial-done'),
                    label: l10n.tutorialOpenCabinet,
                    onPressed: onDone,
                  )
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: 0.2, end: 0, duration: 500.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
