import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/router/resume_location.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/film_strip.dart';
import '../../../../core/widgets/ko_button.dart';
import '../../../../core/widgets/ko_icon_button.dart';
import '../../../../l10n/l10n.dart';
import '../../../case_files/presentation/screen/case_files_screen.dart';
import '../../../content/domain/entities/case_file.dart';
import '../../../progress/domain/entities/case_progress.dart';
import '../../../progress/domain/usecases/progress_rules.dart';
import '../../../progress/presentation/providers/progress_providers.dart';

/// 07 · Banyo. Kayıtlı ilerleme varsa "Kaldığın yer" kartı, yoksa dolaba çağrı.
class DevelopingScreen extends ConsumerWidget {
  const DevelopingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final library = ref.watch(contentRepositoryProvider);
    final active = ref.watch(activeProgressProvider);
    final activeFile = active == null ? null : library.cases[active.caseId];
    return SafeArea(
      child: Stack(
        children: [
          // Kırmızı güvenlik ışığı parıltısı
          const Positioned(
            top: -140,
            left: -60,
            child: IgnorePointer(
              child: SizedBox.square(
                dimension: 300,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                        colors: [Color(0x4DE0503F), Color(0x00E0503F)],
                        stops: [0, 0.7]),
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  KoSpacing.xl, KoSpacing.l, KoSpacing.m, KoSpacing.l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: KoColor.safelight,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: Color(0x8CE0503F),
                                blurRadius: 14,
                                spreadRadius: 4)
                          ],
                        ),
                      ),
                      const SizedBox(width: KoSpacing.s),
                      Text.rich(
                        TextSpan(
                          style: KoText.sectionTitle
                              .copyWith(fontSize: 21, letterSpacing: 1.2),
                          children: [
                            TextSpan(text: context.l10n.brandDark),
                            TextSpan(
                                text: context.l10n.brandRoom,
                                style: const TextStyle(color: KoColor.redText)),
                          ],
                        ),
                      ),
                      const Spacer(),
                      KoIconButton(
                        icon: Icons.settings_outlined,
                        label: context.l10n.settingsTitle,
                        filled: false,
                        onPressed: () => context.push(Routes.settings),
                      ),
                    ],
                  ),
                  const Spacer(),
                  if (active != null && activeFile != null && !active.isClosed)
                    Padding(
                      padding: const EdgeInsets.only(right: KoSpacing.s),
                      child: _ResumeCard(
                        file: activeFile,
                        progress: active,
                        waiting: isWaitingForNextReel(active, library),
                        theoryPending: needsTheory(active, library),
                        onResume: () =>
                            context.push(resumeLocation(active, library)),
                        onCaseFiles: () => context.go(Routes.caseFiles),
                      ),
                    )
                  else
                    Center(
                      child: Column(
                        children: [
                          Text(context.l10n.developingHeadline,
                              style: KoText.sectionTitle,
                              textAlign: TextAlign.center),
                          const SizedBox(height: KoSpacing.s),
                          Text(
                            context.l10n.developingSubtitle,
                            style:
                                KoText.body.copyWith(color: KoColor.textMuted),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: KoSpacing.xl),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: KoSpacing.xxxl),
                            child: KoButton(
                                label: context.l10n.openCaseFiles,
                                onPressed: () => context.go(Routes.caseFiles)),
                          ),
                        ],
                      ),
                    ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 08 · Kaldığın yer: kapak, Dosya adı, rulo/kare, ilerleme ve "Devam et".
class _ResumeCard extends StatelessWidget {
  const _ResumeCard({
    required this.file,
    required this.progress,
    required this.waiting,
    required this.theoryPending,
    required this.onResume,
    required this.onCaseFiles,
  });

  final CaseFile file;
  final CaseProgress progress;

  /// Rulo bitti ama sonraki rulo henüz yok.
  final bool waiting;

  /// Rulo bitti, rulo sonu sorusu cevaplanmadı.
  final bool theoryPending;
  final VoidCallback onResume;
  final VoidCallback onCaseFiles;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final total = file.totalReels * Routes.framesPerReel;
    final solved = progress.solved.length;
    final reelTitle = file.reel(progress.reel)?.title ?? '';
    final frames = file.reel(progress.reel)?.frames ?? const <Frame>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.resumeEyebrow, style: KoText.label),
        const SizedBox(height: KoSpacing.s),
        Container(
          padding: const EdgeInsets.all(KoSpacing.m),
          decoration: BoxDecoration(
            color: KoColor.surface,
            borderRadius: BorderRadius.circular(KoRadius.cardLarge),
            border: Border.all(color: KoColor.line),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CaseCover(file: file, width: 72, height: 92),
                  const SizedBox(width: KoSpacing.m),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.caseNumber(file.number),
                            style:
                                KoText.label.copyWith(color: KoColor.redText)),
                        const SizedBox(height: 2),
                        Text(file.title,
                            style: KoText.cardTitle.copyWith(fontSize: 20)),
                        const SizedBox(height: KoSpacing.xs),
                        Text(
                          waiting
                              ? l10n.reelWaiting(
                                  progress.reel, progress.reel + 1)
                              : theoryPending
                                  ? l10n.resumeTheory(progress.reel)
                                  : '${l10n.resumeWhere(progress.reel, progress.frame)} · $reelTitle',
                          style: KoText.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: KoSpacing.m),
              // Bu rulonun şeridi: banyo edilenler fotoğraf, sıradaki kırmızı çerçeveli.
              // Kenarlardan kırp ama eğik şeridin alt/üst köşelerine pay bırak.
              ClipRect(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: FilmStrip(
                    // Yeni kare çözülünce şerit yeniden kurulur, en son kare yeniden banyo edilir.
                    key: ValueKey('strip-${progress.reel}-$solved'),
                    count: frames.length,
                    current: waiting ||
                            theoryPending ||
                            progress.frame > frames.length
                        ? null
                        : progress.frame - 1,
                    photos: {
                      for (final f in frames)
                        if (progress.isSolved(progress.reel, f.number))
                          f.number - 1: f.photo.asset,
                    },
                    height: 80,
                    tilt: -0.02,
                    // Kart açılınca kareler sırayla belirir; en son çözülen yavaşça banyo edilir.
                    entrance: true,
                  ),
                ),
              ),
              const SizedBox(height: KoSpacing.s),
              Align(
                alignment: Alignment.centerRight,
                child: Text(l10n.caseFramesProgress(solved, total),
                    style: KoText.counter.copyWith(fontSize: 11)),
              ),
            ],
          ),
        ),
        const SizedBox(height: KoSpacing.l),
        KoButton(
          key: const Key('resume'),
          label: waiting ? l10n.reelComingSoon : l10n.resumeButton,
          onPressed: waiting ? null : onResume,
        ),
        const SizedBox(height: KoSpacing.s),
        KoButton.ghost(label: l10n.openCaseFiles, onPressed: onCaseFiles),
      ],
    );
  }
}
