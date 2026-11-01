import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../l10n/l10n.dart';
import '../domain/entities/flow_step.dart';

/// Akış adımını ekrana çevirir. Kare zincirinde her adım bir öncekinin yerine
/// geçer; böylece geri tuşu her zaman Banyo sekmesine döner.
extension FlowNavigator on BuildContext {
  void goToStep(FlowStep step) {
    switch (step) {
      case NextPuzzle(:final caseId, :final reel, :final frame):
        pushReplacement(Routes.puzzle(caseId, reel, frame));
      case ShowScene(:final caseId, :final reel, :final frame):
        pushReplacement(Routes.scene(caseId, reel, frame));
      case AskQuestion(:final caseId, :final reel):
        pushReplacement(Routes.question(caseId, reel));
      case StartReel(:final caseId, :final reel):
        pushReplacement(Routes.reelIntro(caseId, reel));
      case ShowFinale(:final caseId):
        pushReplacement(Routes.finale(caseId));
      case BackToDeveloping():
        backToDeveloping();
    }
  }

  /// Banyo sekmesine dön.
  void backToDeveloping() => canPop() ? pop() : go(Routes.developing);

  /// Rulo sorusundan sonraki düğmenin yazısı.
  String questionDoneLabel(FlowStep step) => switch (step) {
        StartReel() => l10n.questionNextReel,
        ShowFinale() => l10n.questionToFinale,
        _ => l10n.questionBackToDeveloping,
      };
}
