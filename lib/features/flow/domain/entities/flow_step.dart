/// Oyun akışında sıradaki adım. Hangi ekranın açılacağını presentation belirler.
sealed class FlowStep {
  const FlowStep(this.caseId);
  final String caseId;
}

/// Sıradaki karenin bulmacası.
final class NextPuzzle extends FlowStep {
  const NextPuzzle(super.caseId, this.reel, this.frame);
  final int reel;
  final int frame;
}

/// Karenin ardından gelen hikâye anı.
final class ShowScene extends FlowStep {
  const ShowScene(super.caseId, this.reel, this.frame);
  final int reel;
  final int frame;
}

/// Rulo bitti: rulo sonu sorusu.
final class AskQuestion extends FlowStep {
  const AskQuestion(super.caseId, this.reel);
  final int reel;
}

/// Sonraki rulonun başlangıcı.
final class StartReel extends FlowStep {
  const StartReel(super.caseId, this.reel);
  final int reel;
}

/// Son karar.
final class ShowFinale extends FlowStep {
  const ShowFinale(super.caseId);
}

/// Yapılacak bir şey kalmadı (sonraki rulo henüz yazılmadı): Banyo sekmesi.
final class BackToDeveloping extends FlowStep {
  const BackToDeveloping(super.caseId);
}
