import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/l10n.dart';
import '../../../puzzle/presentation/widgets/nonogram_board.dart';
import '../view_model/tutorial_view_model.dart';
import 'hand_pointer.dart';

/// Öğreticinin ızgarası; adımın hareketini gösteren el işareti üstünde yürür.
class TutorialBoard extends ConsumerWidget {
  const TutorialBoard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tutorialViewModelProvider);
    final vm = ref.read(tutorialViewModelProvider.notifier);
    final showHand = !state.done && !state.stroking;

    return NonogramBoard(
      board: state.board,
      showMistakes: true,
      activeRow: state.activeRow,
      activeCol: state.activeCol,
      semanticLabel: context.l10n.puzzleGridLabel(5, 5),
      onStrokeStart: vm.touchDown,
      onStrokeExtend: vm.touchMove,
      onStrokeEnd: vm.touchUp,
      gridOverlay: showHand ? (cell) => _hand(state.step, cell) : null,
    );
  }

  /// Adıma göre elin yolu (kare merkezleri).
  static Widget _hand(int step, double cell) {
    Offset at(int r, int c) => Offset(cell * (c + 0.5), cell * (r + 0.5));
    final (from, to) = switch (step) {
      0 => (at(0, 0), at(0, 4)), // en üst satır boyunca
      1 => (at(0, 4), at(4, 4)), // en sağ sütun boyunca
      _ => (at(1, 2), at(1, 2)), // ortadaki kareye dokun
    };
    if (step > 2) return const SizedBox.shrink();
    return HandPointer(key: ValueKey('hand-$step'), from: from, to: to);
  }
}
