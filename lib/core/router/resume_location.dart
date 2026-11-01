import '../../features/content/domain/repositories/content_repository.dart';
import '../../features/progress/domain/entities/case_progress.dart';
import '../../features/progress/domain/entities/resume_target.dart';
import '../../features/progress/domain/usecases/progress_rules.dart';
import 'routes.dart';

/// Kalınan yerin adresi: domain'in kararını ([resumeTarget]) ekrana çevirir.
String resumeLocation(CaseProgress p, ContentRepository content) =>
    switch (resumeTarget(p, content)) {
      ResumePuzzle(:final caseId, :final reel, :final frame) =>
        Routes.puzzle(caseId, reel, frame),
      ResumeInspect(:final caseId, :final reel, :final frame) =>
        Routes.inspect(caseId, reel, frame),
      ResumeQuestion(:final caseId, :final reel) =>
        Routes.question(caseId, reel),
      ResumeReelIntro(:final caseId, :final reel) =>
        Routes.reelIntro(caseId, reel),
      ResumeFinale(:final caseId) => Routes.finale(caseId),
      ResumeEnding(:final caseId) => Routes.ending(caseId),
      ResumeCaseDetail(:final caseId) => Routes.caseDetail(caseId),
    };
