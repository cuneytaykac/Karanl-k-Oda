import '../../../content/domain/repositories/content_repository.dart';
import '../entities/flow_step.dart';

/// Oyun akışının kuralları: bir ekran bitince sırada ne var.
/// Saf fonksiyonlar; ilerleme kaydı ve ekran geçişi bunların dışında yapılır.
abstract final class NextStep {
  /// İnceleme bitti: karenin sahnesi varsa o, yoksa [afterFrame].
  static FlowStep afterInspect(
      ContentRepository content, String caseId, int reel, int frame) {
    if (content.frame(caseId, reel, frame)?.scene != null) {
      return ShowScene(caseId, reel, frame);
    }
    return afterFrame(content, caseId, reel, frame);
  }

  /// Kare (ve varsa sahnesi) bitti: sonraki karenin bulmacası; rulonun son
  /// karesiyse rulo sonu sorusu, sorusu yoksa Banyo.
  static FlowStep afterFrame(
      ContentRepository content, String caseId, int reel, int frame) {
    if (frame < content.framesIn(caseId, reel)) {
      return NextPuzzle(caseId, reel, frame + 1);
    }
    if (content.cases[caseId]?.reel(reel)?.question != null) {
      return AskQuestion(caseId, reel);
    }
    return BackToDeveloping(caseId);
  }

  /// Rulo sorusu cevaplandı: sonraki rulo; son rulonun sorusuysa son karar.
  static FlowStep afterQuestion(
      ContentRepository content, String caseId, int reel) {
    final file = content.cases[caseId];
    if (file?.reel(reel + 1) != null) return StartReel(caseId, reel + 1);
    final isLastReel =
        file != null && file.reels.isNotEmpty && reel == file.reels.last.number;
    if (isLastReel && file.finale != null) return ShowFinale(caseId);
    return BackToDeveloping(caseId);
  }
}
