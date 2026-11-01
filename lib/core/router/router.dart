import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/ads/presentation/providers/ads_coordinator.dart';
import '../../features/case_files/presentation/screen/case_detail_screen.dart';
import '../../features/case_files/presentation/screen/case_files_screen.dart';
import '../../features/case_files/presentation/screen/case_opening_screen.dart';
import '../../features/case_files/presentation/screen/reel_intro_screen.dart';
import '../../features/develop/domain/entities/frame_result.dart';
import '../../features/develop/presentation/screen/develop_screen.dart';
import '../../features/develop/presentation/screen/negative_screen.dart';
import '../../features/developing/presentation/screen/developing_screen.dart';
import '../../features/finale/presentation/screen/finale_screen.dart';
import '../../features/flow/domain/entities/flow_step.dart';
import '../../features/flow/domain/usecases/next_step.dart';
import '../../features/flow/presentation/flow_navigator.dart';
import '../../features/inspect/presentation/screen/inspect_screen.dart';
import '../../features/notebook/presentation/screen/notebook_screen.dart';
import '../../features/onboarding/presentation/screen/tutorial_screen.dart';
import '../../features/onboarding/presentation/screen/welcome_screen.dart';
import '../../features/progress/presentation/providers/progress_providers.dart';
import '../../features/puzzle/presentation/screen/puzzle_screen.dart';
import '../../features/question/presentation/screen/reel_question_screen.dart';
import '../../features/settings/presentation/screen/settings_screen.dart';
import '../../features/story/presentation/screen/story_screen.dart';
import '../../features/story/presentation/widgets/story_line.dart';
import '../../l10n/l10n.dart';
import '../di/providers.dart';
import '../onboarding/onboarding.dart';
import '../widgets/app_shell.dart';
import 'routes.dart';

/// /x/:caseId/:reel/:frame adreslerinden kareyi okur.
({String caseId, int reel, int frame}) _frameOf(GoRouterState s) => (
      caseId: s.pathParameters['caseId']!,
      reel: int.parse(s.pathParameters['reel']!),
      frame: int.parse(s.pathParameters['frame']!),
    );

/// Karanlık odada sayfalar kesmeden değil, yumuşakça kararıp açılarak geçer.
CustomTransitionPage<void> _fade(GoRouterState state, Widget child) =>
    CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 350),
      transitionsBuilder: (_, animation, __, child) => FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          child: child),
    );

Widget _missing(BuildContext context, GoRouterState state) => Scaffold(
    body: Center(child: Text(context.l10n.pageNotFound('${state.uri}'))));

/// Kare (ve varsa sahnesi) bitti: sıradaki kare kaydedilir (rulo sonuysa kare
/// sayısını aşar = rulo bitti), sonra akışın sıradaki adımı açılır.
void _finishFrame(BuildContext context, Ref ref, FlowStep next,
    ({String caseId, int reel, int frame}) f) {
  ref.read(progressProvider.notifier).advanceTo(f.caseId, f.reel, f.frame + 1);
  context.goToStep(next);
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: Routes.developing,
    // İlk açılışta önce giriş hikâyesi ve öğretici bulmaca.
    redirect: (context, state) {
      final onboarded = ref.read(onboardingProvider);
      final loc = state.matchedLocation;
      final inOnboarding = loc == Routes.welcome || loc == Routes.tutorial;
      if (!onboarded && !inOnboarding) return Routes.welcome;
      return null;
    },
    routes: [
      // Alt menülü üç sekme. Her sekme kendi geçmişini korur.
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
                path: Routes.developing,
                builder: (_, __) => const DevelopingScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: Routes.caseFiles,
                builder: (_, __) => const CaseFilesScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: Routes.notebook,
                builder: (_, __) => const NotebookScreen()),
          ]),
        ],
      ),

      // İlk açılış.
      GoRoute(
        path: Routes.welcome,
        pageBuilder: (context, state) => _fade(
            state, WelcomeScreen(onDone: () => context.go(Routes.tutorial))),
      ),
      GoRoute(
        path: Routes.tutorial,
        pageBuilder: (context, state) => _fade(
          state,
          TutorialScreen(
            onDone: () {
              ref.read(onboardingProvider.notifier).complete();
              context.go(Routes.caseFiles);
            },
          ),
        ),
      ),

      // Alt menüsüz, tam ekran sayfalar.
      GoRoute(
          path: Routes.settings, builder: (_, __) => const SettingsScreen()),

      // Dosya girişi: Dosya sayfası → Açılış → Rulo başlangıcı → Kare 1.
      GoRoute(
        path: '/case/:caseId',
        builder: (context, state) {
          final file = ref
              .read(contentRepositoryProvider)
              .cases[state.pathParameters['caseId']];
          if (file == null) return _missing(context, state);
          return CaseDetailScreen(
            file: file,
            onBack: () =>
                context.canPop() ? context.pop() : context.go(Routes.caseFiles),
            onOpen: () => context.push(Routes.caseOpening(file.id)),
            onResume: (location) => context.push(location),
          );
        },
      ),
      GoRoute(
        path: '/case/:caseId/opening',
        pageBuilder: (context, state) {
          final file = ref
              .read(contentRepositoryProvider)
              .cases[state.pathParameters['caseId']];
          if (file == null) return _fade(state, _missing(context, state));
          return _fade(
            state,
            CaseOpeningScreen(
              file: file,
              onBack: () => context.canPop()
                  ? context.pop()
                  : context.go(Routes.caseFiles),
              onDone: () {
                ref.read(progressProvider.notifier).start(file.id);
                context.pushReplacement(Routes.reelIntro(file.id, 1));
              },
            ),
          );
        },
      ),
      GoRoute(
        path: '/reel/:caseId/:reel',
        pageBuilder: (context, state) {
          final file = ref
              .read(contentRepositoryProvider)
              .cases[state.pathParameters['caseId']];
          final reel =
              file?.reel(int.tryParse(state.pathParameters['reel'] ?? '') ?? 0);
          if (file == null || reel == null) {
            return _fade(state, _missing(context, state));
          }
          return _fade(
            state,
            ReelIntroScreen(
              file: file,
              reel: reel,
              onBack: () => context.canPop()
                  ? context.pop()
                  : context.go(Routes.caseFiles),
              // Makara sesi ve sarma animasyonu ekranın kendisinde.
              onStart: () => context
                  .pushReplacement(Routes.puzzle(file.id, reel.number, 1)),
            ),
          );
        },
      ),

      // Kare akışı: Bulmaca → Negatif → Banyo → İnceleme → sonraki karenin bulmacası.
      // Her adım bir öncekinin yerine geçer (pushReplacement); böylece geri tuşu
      // her zaman Banyo sekmesine döner ve çözülmüş bulmacaya geri dönülmez.
      GoRoute(
        path: '/puzzle/:caseId/:reel/:frame',
        builder: (_, state) {
          final f = _frameOf(state);
          return PuzzleScreen(caseId: f.caseId, reel: f.reel, frame: f.frame);
        },
      ),
      GoRoute(
        path: '/negative/:caseId/:reel/:frame',
        pageBuilder: (context, state) {
          final f = _frameOf(state);
          return _fade(
            state,
            NegativeScreen(
              caseId: f.caseId,
              reel: f.reel,
              frame: f.frame,
              result: state.extra is FrameResult
                  ? state.extra! as FrameResult
                  : null,
              puzzle: ref
                  .read(contentRepositoryProvider)
                  .puzzleFor(f.caseId, f.reel, f.frame),
              onDevelop: () => context
                  .pushReplacement(Routes.develop(f.caseId, f.reel, f.frame)),
            ),
          );
        },
      ),
      GoRoute(
        path: '/develop/:caseId/:reel/:frame',
        pageBuilder: (context, state) {
          final f = _frameOf(state);
          return _fade(
            state,
            DevelopScreen(
              photoAsset: ref
                  .read(contentRepositoryProvider)
                  .photoFor(f.caseId, f.reel, f.frame)
                  .asset,
              onFinished: () => context
                  .pushReplacement(Routes.inspect(f.caseId, f.reel, f.frame)),
            ),
          );
        },
      ),
      GoRoute(
        path: '/inspect/:caseId/:reel/:frame',
        pageBuilder: (context, state) {
          final f = _frameOf(state);
          final library = ref.read(contentRepositoryProvider);
          final file = library.cases[f.caseId];
          final content = library.frame(f.caseId, f.reel, f.frame);
          final reaction = content?.reaction;
          return _fade(
            state,
            InspectScreen(
              caseId: f.caseId,
              reel: f.reel,
              frame: f.frame,
              reaction: file == null || reaction == null
                  ? null
                  : StoryLine(line: reaction, file: file, compact: true),
              // İçerikte yazılı değilse (örnek kareler) arama karesi say.
              search: content?.search ?? true,
              onClose: context.backToDeveloping,
              onNext: () {
                final next =
                    NextStep.afterInspect(library, f.caseId, f.reel, f.frame);
                // Sahne varsa kare sahneden sonra biter.
                next is ShowScene
                    ? context.goToStep(next)
                    : _finishFrame(context, ref, next, f);
              },
            ),
          );
        },
      ),
      GoRoute(
        path: '/question/:caseId/:reel',
        pageBuilder: (context, state) {
          final library = ref.read(contentRepositoryProvider);
          final file = library.cases[state.pathParameters['caseId']];
          final reelNo = int.tryParse(state.pathParameters['reel'] ?? '') ?? 0;
          final question = file?.reel(reelNo)?.question;
          if (file == null || question == null) {
            return _fade(state, _missing(context, state));
          }
          final next = NextStep.afterQuestion(library, file.id, reelNo);
          return _fade(
            state,
            ReelQuestionScreen(
              file: file,
              reel: reelNo,
              question: question,
              onBack: context.backToDeveloping,
              doneLabel: context.questionDoneLabel(next),
              onDone: () async {
                // Rulo arası: kurallar izin veriyorsa geçiş reklamı.
                if (next is StartReel) {
                  await ref
                      .read(adsCoordinatorProvider)
                      .reelBreak(nextReel: next.reel);
                }
                if (context.mounted) context.goToStep(next);
              },
            ),
          );
        },
      ),
      GoRoute(
        path: '/finale/:caseId',
        pageBuilder: (context, state) {
          final file = ref
              .read(contentRepositoryProvider)
              .cases[state.pathParameters['caseId']];
          final finale = file?.finale;
          if (file == null || finale == null) {
            return _fade(state, _missing(context, state));
          }
          return _fade(
            state,
            FinaleScreen(
              file: file,
              finale: finale,
              onBack: () => context.canPop()
                  ? context.pop()
                  : context.go(Routes.developing),
              onConfirmed: () =>
                  context.pushReplacement(Routes.ending(file.id)),
            ),
          );
        },
      ),
      GoRoute(
        path: '/ending/:caseId',
        pageBuilder: (context, state) {
          final file = ref
              .read(contentRepositoryProvider)
              .cases[state.pathParameters['caseId']];
          final finale = file?.finale;
          final choice = finale
              ?.option(ref.read(progressProvider)[file?.id ?? '']?.ending);
          if (file == null || finale == null || choice == null) {
            return _fade(state, _missing(context, state));
          }
          return _fade(
            state,
            StoryScreen(
              storyId: 'ending/${file.id}',
              eyebrow:
                  '${context.l10n.caseNumber(file.number)} · ${context.l10n.caseStatusClosed}',
              title: choice.text,
              lines: [...choice.ending, ...finale.epilogue],
              file: file,
              doneLabel: context.l10n.backToCaseFiles,
              onBack: () => context.go(Routes.caseFiles),
              onDone: () => context.go(Routes.caseFiles),
            ),
          );
        },
      ),
      GoRoute(
        path: '/scene/:caseId/:reel/:frame',
        pageBuilder: (context, state) {
          final f = _frameOf(state);
          final library = ref.read(contentRepositoryProvider);
          final file = library.cases[f.caseId];
          final scene = library.frame(f.caseId, f.reel, f.frame)?.scene;
          if (file == null || scene == null) {
            return _fade(state, _missing(context, state));
          }
          final next = NextStep.afterFrame(library, f.caseId, f.reel, f.frame);
          return _fade(
            state,
            StoryScreen(
              storyId: 'scene/${f.caseId}/${f.reel}/${f.frame}',
              eyebrow: scene.eyebrow,
              title: scene.title,
              lines: scene.lines,
              file: file,
              doneLabel: next is NextPuzzle
                  ? context.l10n.inspectNextFrame(f.frame + 1)
                  : context.l10n.done,
              onBack: context.backToDeveloping,
              onDone: () => _finishFrame(context, ref, next, f),
            ),
          );
        },
      ),
    ],
    errorBuilder: _missing,
  );
});
