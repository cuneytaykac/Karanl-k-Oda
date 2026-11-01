import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../l10n/l10n.dart';
import '../../../content/domain/entities/case_file.dart';
import '../../../progress/domain/entities/case_progress.dart';
import '../../../progress/presentation/providers/progress_providers.dart';

/// 10 · Dosyalar: dolaptaki filmler. İçerik kütüphaneden gelir.
/// (Açık/Kapandı süzgeci ilerleme kaydı geldiğinde eklenecek.)
class CaseFilesScreen extends ConsumerWidget {
  const CaseFilesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final cases = ref.watch(contentRepositoryProvider).ordered;
    final progress = ref.watch(progressProvider);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
            KoSpacing.l, KoSpacing.xxl, KoSpacing.l, KoSpacing.xxl),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: KoSpacing.xs),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.caseFilesEyebrow, style: KoText.label),
                const SizedBox(height: 2),
                Text(l10n.caseFilesTitle, style: KoText.screenTitle),
              ],
            ),
          ),
          const SizedBox(height: KoSpacing.l),
          for (final c in cases) ...[
            _CaseCard(
              key: Key('case-${c.id}'),
              file: c,
              progress: progress[c.id],
              onTap: () => context.push(Routes.caseDetail(c.id)),
            ),
            const SizedBox(height: KoSpacing.m),
          ],
          for (final u in ref.watch(contentRepositoryProvider).upcoming) ...[
            _UpcomingCard(number: u.number, title: u.title, blurb: u.blurb),
            const SizedBox(height: KoSpacing.m),
          ],
        ],
      ),
    );
  }
}

class _CaseCard extends StatelessWidget {
  const _CaseCard(
      {super.key, required this.file, required this.onTap, this.progress});
  final CaseFile file;
  final CaseProgress? progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Material(
      color: KoColor.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(KoRadius.card),
        side: const BorderSide(color: KoColor.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CaseCover(file: file, width: 84, height: 108),
              const SizedBox(width: KoSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${l10n.caseNumber(file.number)} · ${progress == null ? l10n.caseStatusNew : progress!.isClosed ? l10n.caseStatusClosed : l10n.caseStatusInProgress}',
                      style: KoText.label.copyWith(
                        color: progress == null
                            ? KoColor.redText
                            : (progress!.isClosed
                                ? KoColor.textDim
                                : KoColor.amber),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(file.title,
                        style: KoText.cardTitle.copyWith(fontSize: 19)),
                    const SizedBox(height: 4),
                    Text(
                      file.summary,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: KoText.bodySmall.copyWith(fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    if (progress == null)
                      Text(file.tags.take(3).join(' · '),
                          style: KoText.counter.copyWith(fontSize: 11))
                    else
                      _ProgressBar(
                          solved: progress!.solved.length,
                          total: file.totalReels * 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UpcomingCard extends StatelessWidget {
  const _UpcomingCard(
      {required this.number, required this.title, required this.blurb});
  final int number;
  final String title;
  final String blurb;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF151211),
        borderRadius: BorderRadius.circular(KoRadius.card),
        border: Border.all(color: const Color(0xFF342E2A)),
      ),
      child: Row(
        children: [
          Container(
            width: 84,
            height: 108,
            decoration: BoxDecoration(
                color: KoColor.surface2,
                borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.lock_outline_rounded,
                color: KoColor.textDisabled),
          ),
          const SizedBox(width: KoSpacing.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.caseNumber(number),
                    style: KoText.label.copyWith(color: KoColor.textDim)),
                const SizedBox(height: 2),
                Text(title,
                    style: KoText.cardTitle
                        .copyWith(fontSize: 19, color: KoColor.textCream)),
                const SizedBox(height: 4),
                Text(blurb,
                    style: KoText.bodySmall
                        .copyWith(fontSize: 12, color: KoColor.textDim)),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(KoRadius.pill),
                    border: Border.all(color: const Color(0xFF342E2A)),
                  ),
                  child: Text(l10n.caseComingSoon,
                      style: KoText.bodySmall
                          .copyWith(fontSize: 11.5, color: KoColor.textDim)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Dosyanın kapak fotoğrafı (ilk karenin fotoğrafı, kırpılmış).
class CaseCover extends StatelessWidget {
  const CaseCover(
      {super.key,
      required this.file,
      required this.width,
      required this.height,
      this.radius = 10});
  final CaseFile file;
  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final cover = file.cover;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: width,
        height: height,
        child: cover == null
            ? const ColoredBox(color: KoColor.surface2)
            : SvgPicture.asset(
                cover,
                fit: BoxFit.cover,
                excludeFromSemantics: true,
                placeholderBuilder: (_) =>
                    const ColoredBox(color: KoColor.surface2),
              ),
      ),
    );
  }
}

/// İnce ilerleme çubuğu ve "12/70 kare".
class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.solved, required this.total});
  final int solved;
  final int total;

  @override
  Widget build(BuildContext context) {
    final share = total == 0 ? 0.0 : (solved / total).clamp(0.0, 1.0);
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(KoRadius.pill),
            child: LinearProgressIndicator(
              value: share,
              minHeight: 4,
              backgroundColor: KoColor.lineStrong,
              color: KoColor.completed,
            ),
          ),
        ),
        const SizedBox(width: KoSpacing.s),
        Text(context.l10n.caseFramesProgress(solved, total),
            style: KoText.counter.copyWith(fontSize: 11)),
      ],
    );
  }
}
