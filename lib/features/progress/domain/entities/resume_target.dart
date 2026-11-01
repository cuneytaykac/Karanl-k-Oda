/// Oyuncunun kaldığı yer. Hangi ekranın açılacağı presentation katmanında belirlenir.
sealed class ResumeTarget {
  const ResumeTarget(this.caseId);
  final String caseId;
}

/// Kare çözülmedi: bulmacası.
final class ResumePuzzle extends ResumeTarget {
  const ResumePuzzle(super.caseId, this.reel, this.frame);
  final int reel;
  final int frame;
}

/// Kare çözüldü ama incelenmedi (banyo tekrar edilmez).
final class ResumeInspect extends ResumeTarget {
  const ResumeInspect(super.caseId, this.reel, this.frame);
  final int reel;
  final int frame;
}

/// Rulo bitti, sorusu cevap bekliyor.
final class ResumeQuestion extends ResumeTarget {
  const ResumeQuestion(super.caseId, this.reel);
  final int reel;
}

/// Sonraki rulonun başlangıcı.
final class ResumeReelIntro extends ResumeTarget {
  const ResumeReelIntro(super.caseId, this.reel);
  final int reel;
}

/// Son karar bekleniyor.
final class ResumeFinale extends ResumeTarget {
  const ResumeFinale(super.caseId);
}

/// Dosya kapandı: kapanış.
final class ResumeEnding extends ResumeTarget {
  const ResumeEnding(super.caseId);
}

/// Sonraki rulo henüz yazılmadı: Dosya sayfası.
final class ResumeCaseDetail extends ResumeTarget {
  const ResumeCaseDetail(super.caseId);
}
