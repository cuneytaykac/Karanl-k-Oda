import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/router/resume_location.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/ko_button.dart';
import '../../../../core/widgets/ko_icon_button.dart';
import '../../../../l10n/l10n.dart';
import '../../../content/domain/entities/case_file.dart';
import '../../../progress/domain/usecases/progress_rules.dart';
import '../../../progress/presentation/providers/progress_providers.dart';
import 'case_files_screen.dart';

/// 11 · Dosya sayfası (yeni): kapak, özet, etiketler, kişiler, "Dosyayı aç".
class CaseDetailScreen extends ConsumerWidget {
  const CaseDetailScreen(
      {super.key,
      required this.file,
      required this.onOpen,
      required this.onBack,
      required this.onResume});

  final CaseFile file;
  final VoidCallback onOpen;
  final VoidCallback onBack;

  /// Kayıtlı ilerleme varsa kalınan yere git (adres verilir).
  final ValueChanged<String> onResume;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final library = ref.watch(contentRepositoryProvider);
    final progress = ref.watch(progressProvider.select((m) => m[file.id]));
    final waiting = progress != null && isWaitingForNextReel(progress, library);
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(
                  height: 290,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CaseCover(
                          file: file, width: width, height: 290, radius: 0),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0, 0.1),
                            end: Alignment.bottomCenter,
                            colors: [Color(0x00100E0D), KoColor.background],
                          ),
                        ),
                      ),
                      SafeArea(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(KoSpacing.m),
                            child: KoIconButton(
                                icon: Icons.chevron_left,
                                label: l10n.back,
                                onPressed: onBack),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      KoSpacing.xl, 0, KoSpacing.xl, KoSpacing.l),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${l10n.caseNumber(file.number)} · ${progress == null ? l10n.caseStatusNew : progress.isClosed ? l10n.caseStatusClosed : l10n.caseStatusInProgress}',
                        style: KoText.label.copyWith(color: KoColor.redText),
                      ),
                      const SizedBox(height: KoSpacing.xs),
                      Text(file.title, style: KoText.display),
                      const SizedBox(height: KoSpacing.s),
                      Text(file.summary, style: KoText.body),
                      const SizedBox(height: KoSpacing.m),
                      Wrap(
                        spacing: KoSpacing.s,
                        runSpacing: KoSpacing.s,
                        children: [for (final t in file.tags) _Tag(t)],
                      ),
                      const SizedBox(height: KoSpacing.xl),
                      Text(l10n.casePeopleCount(file.people.length),
                          style: KoText.label),
                      const SizedBox(height: KoSpacing.s),
                      Wrap(
                        spacing: KoSpacing.s,
                        runSpacing: KoSpacing.s,
                        children: [
                          for (final p in file.people) _Avatar(person: p)
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  KoSpacing.l, KoSpacing.s, KoSpacing.l, KoSpacing.l),
              child: Column(
                children: [
                  if (progress == null)
                    KoButton(
                        key: const Key('case-open'),
                        label: l10n.caseOpen,
                        onPressed: onOpen)
                  else if (progress.isClosed)
                    KoButton.ghost(
                      key: const Key('case-reread'),
                      label: l10n.caseReread,
                      onPressed: () =>
                          onResume(resumeLocation(progress, library)),
                    )
                  else if (waiting)
                    KoButton(
                        key: const Key('case-resume'),
                        label:
                            l10n.reelWaiting(progress.reel, progress.reel + 1),
                        onPressed: null)
                  else
                    KoButton(
                      key: const Key('case-resume'),
                      label: needsTheory(progress, library)
                          ? '${l10n.resumeButton} · ${l10n.resumeTheory(progress.reel)}'
                          : l10n.resumeAt(progress.reel, progress.frame),
                      onPressed: () =>
                          onResume(resumeLocation(progress, library)),
                    ),
                  const SizedBox(height: KoSpacing.s),
                  Text(
                    progress == null
                        ? l10n.caseOneAtATime
                        : progress.isClosed
                            ? l10n.caseYourDecision(
                                file.finale?.option(progress.ending)?.text ??
                                    '')
                            : l10n.caseFramesProgress(
                                progress.solved.length, file.totalReels * 10),
                    style: KoText.bodySmall
                        .copyWith(fontSize: 12, color: KoColor.textDim),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(KoRadius.pill),
          border: Border.all(color: KoColor.lineStrong),
        ),
        child: Text(text,
            style: KoText.bodySmall
                .copyWith(fontSize: 12, color: KoColor.textCream)),
      );
}

/// Bilinen kişi baş harfiyle; henüz tanışılmamış kişi "?" ile.
class _Avatar extends StatelessWidget {
  const _Avatar({required this.person});
  final Person person;

  @override
  Widget build(BuildContext context) {
    final known = person.known;
    return Semantics(
      label: known ? person.name : null,
      child: Container(
        width: 46,
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: known ? KoColor.paper : Colors.transparent,
          border: known
              ? null
              : Border.all(color: const Color(0xFF4A3F37), width: 2),
        ),
        child: Text(
          known ? person.initial : '?',
          style: KoText.cardTitle
              .copyWith(color: known ? KoColor.ink : KoColor.textDisabled),
        ),
      ),
    );
  }
}
