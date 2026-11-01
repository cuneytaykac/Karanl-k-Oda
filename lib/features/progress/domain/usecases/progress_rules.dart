import '../../../content/domain/repositories/content_repository.dart';
import '../entities/case_progress.dart';
import '../entities/resume_target.dart';

/// Kare sayısı: her rulo 10 kare (yazılmamış rulolar dahil).
const framesPerReel = 10;

/// Kalınan yer.
/// - Kare çözülmediyse bulmacası, çözüldüyse incelemesi.
/// - Rulo bittiyse sorusu, sonra sonraki rulonun başlangıcı; o rulo yoksa final ya da Dosya sayfası.
ResumeTarget resumeTarget(CaseProgress p, ContentRepository content) {
  final file = content.cases[p.caseId];
  final framesInReel = file?.reel(p.reel)?.frames.length ?? 0;
  if (p.frame <= framesInReel) {
    return p.isSolved(p.reel, p.frame)
        ? ResumeInspect(p.caseId, p.reel, p.frame)
        : ResumePuzzle(p.caseId, p.reel, p.frame);
  }
  if (needsTheory(p, content)) return ResumeQuestion(p.caseId, p.reel);
  if (file?.reel(p.reel + 1) != null) {
    return ResumeReelIntro(p.caseId, p.reel + 1);
  }
  if (needsFinale(p, content)) return ResumeFinale(p.caseId);
  if (p.isClosed) return ResumeEnding(p.caseId);
  return ResumeCaseDetail(p.caseId);
}

/// Bir rulonun bittiği ama sonraki rulonun henüz yazılmadığı durum.
bool isWaitingForNextReel(CaseProgress p, ContentRepository content) {
  final file = content.cases[p.caseId];
  final framesInReel = file?.reel(p.reel)?.frames.length ?? 0;
  return file != null &&
      p.frame > framesInReel &&
      !needsTheory(p, content) &&
      file.reel(p.reel + 1) == null &&
      file.finale == null;
}

/// Son rulo ve sorusu bitti, final var ama son karar verilmedi.
bool needsFinale(CaseProgress p, ContentRepository content) {
  final file = content.cases[p.caseId];
  if (file == null || file.finale == null || p.isClosed) return false;
  final last = file.reels.isEmpty ? null : file.reels.last;
  if (last == null || p.reel != last.number || p.frame <= last.frames.length) {
    return false;
  }
  return !needsTheory(p, content);
}

/// Rulo bitti, sorusu var ama oyuncu henüz teorisini vermedi.
bool needsTheory(CaseProgress p, ContentRepository content) {
  final reel = content.cases[p.caseId]?.reel(p.reel);
  if (reel == null || p.frame <= reel.frames.length) return false;
  return reel.question != null && !p.theories.containsKey(p.reel);
}

/// Dosyadaki çözülmüş kare sayısı ve toplam kare sayısı.
({int solved, int total}) frameCount(
    CaseProgress? p, ContentRepository content, String caseId) {
  final file = content.cases[caseId];
  final total = (file?.totalReels ?? 0) * framesPerReel;
  return (solved: p?.solved.length ?? 0, total: total);
}
