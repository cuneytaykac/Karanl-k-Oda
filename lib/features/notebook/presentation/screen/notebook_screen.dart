import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/ko_button.dart';
import '../../../../core/widgets/ko_photo.dart';
import '../../../../l10n/l10n.dart';
import '../../../content/domain/entities/case_file.dart';
import '../../../content/domain/entities/photo_spec.dart';
import '../../../progress/domain/entities/case_progress.dart';
import '../../../progress/presentation/providers/progress_providers.dart';
import '../providers/notebook_store.dart';

/// 35–42 · Defter: en son oynanan Dosya'nın kişileri, ipuçları, zaman çizelgesi ve teorileri.
class NotebookScreen extends ConsumerWidget {
  const NotebookScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final library = ref.watch(contentRepositoryProvider);
    final active = ref.watch(activeProgressProvider);
    final file = active == null ? null : library.cases[active.caseId];
    if (active == null || file == null) return const _EmptyNotebook();

    final l10n = context.l10n;
    final clues =
        ref.watch(notebookProvider).where((c) => c.caseId == file.id).toList();
    final metIds = {
      for (final p in file.people)
        if (p.known) p.id,
      for (final c in clues)
        if (c.personId != null) c.personId!,
    };
    final found = clues.where((c) => c.kind == HotspotKind.clue).toList();
    final times = clues.where((c) => c.kind == HotspotKind.time).toList();

    return SafeArea(
      child: DefaultTabController(
        length: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  KoSpacing.xl, KoSpacing.xxl, KoSpacing.xl, KoSpacing.s),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '${l10n.notebookEyebrow} · ${l10n.caseNumber(file.number)}',
                      style: KoText.label),
                  const SizedBox(height: 2),
                  Text(file.title, style: KoText.screenTitle),
                ],
              ),
            ),
            TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              padding: const EdgeInsets.symmetric(horizontal: KoSpacing.m),
              labelStyle: KoText.buttonSmall,
              unselectedLabelStyle:
                  KoText.buttonSmall.copyWith(fontWeight: FontWeight.w400),
              labelColor: KoColor.text,
              unselectedLabelColor: KoColor.textDim,
              indicatorColor: KoColor.safelight,
              indicatorSize: TabBarIndicatorSize.label,
              dividerColor: KoColor.line,
              tabs: [
                Tab(
                    text:
                        '${l10n.notebookTabPeople} ${metIds.length}/${file.people.length}'),
                Tab(text: '${l10n.notebookTabClues} ${found.length}'),
                Tab(text: l10n.notebookTabTimeline),
                Tab(text: l10n.notebookTabTheories),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _PeopleTab(file: file, clues: clues, metIds: metIds),
                  _CluesTab(clues: found),
                  _TimelineTab(file: file, times: times),
                  _TheoriesTab(file: file, progress: active),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------- Kişiler

class _PeopleTab extends StatelessWidget {
  const _PeopleTab(
      {required this.file, required this.clues, required this.metIds});
  final CaseFile file;
  final List<NotebookClue> clues;
  final Set<String> metIds;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListView(
      padding: const EdgeInsets.all(KoSpacing.l),
      children: [
        for (final p in file.people) ...[
          Builder(builder: (context) {
            final met = metIds.contains(p.id);
            NotebookClue? last;
            for (final c in clues) {
              if (c.personId == p.id) last = c;
            }
            final note = last;
            return _Card(
              dim: !met,
              onTap: note == null ? null : () => _showPhoto(context, note),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: met ? KoColor.paper : Colors.transparent,
                      border: met
                          ? null
                          : Border.all(
                              color: const Color(0xFF4A3F37), width: 2),
                    ),
                    child: Text(
                      met ? p.initial : '?',
                      style: KoText.cardTitle.copyWith(
                          color: met ? KoColor.ink : KoColor.textDisabled),
                    ),
                  ),
                  const SizedBox(width: KoSpacing.m),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(met ? p.name : l10n.notebookUnknownName,
                            style: KoText.cardTitle.copyWith(fontSize: 16)),
                        const SizedBox(height: 2),
                        Text(met ? p.role : l10n.notebookUnknownPerson,
                            style: KoText.bodySmall),
                        if (note != null) ...[
                          const SizedBox(height: KoSpacing.s),
                          Text(note.body,
                              style: KoText.body.copyWith(fontSize: 13)),
                          const SizedBox(height: KoSpacing.xs),
                          Text(note.source,
                              style: KoText.counter.copyWith(
                                  fontSize: 11, color: KoColor.textDim)),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: KoSpacing.s),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------- İpuçları

class _CluesTab extends StatelessWidget {
  const _CluesTab({required this.clues});
  final List<NotebookClue> clues;

  @override
  Widget build(BuildContext context) {
    if (clues.isEmpty) return _EmptyTab(text: context.l10n.notebookNoClues);
    return ListView(
      padding: const EdgeInsets.all(KoSpacing.l),
      children: [
        for (final c in clues.reversed) ...[
          _Card(
            key: Key('clue-${c.id}'),
            onTap: () => _showPhoto(context, c),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (c.tag != null) ...[
                  _TagChip(c.tag!),
                  const SizedBox(width: KoSpacing.m),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c.title,
                          style: KoText.cardTitle.copyWith(fontSize: 16)),
                      const SizedBox(height: 4),
                      Text(c.body, style: KoText.body.copyWith(fontSize: 13)),
                      const SizedBox(height: KoSpacing.s),
                      Row(
                        children: [
                          Text(c.source,
                              style: KoText.counter.copyWith(
                                  fontSize: 11, color: KoColor.textDim)),
                          const Spacer(),
                          const Icon(Icons.photo_outlined,
                              size: 16, color: KoColor.textDim),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: KoSpacing.s),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------- Zaman

class _TimelineTab extends StatelessWidget {
  const _TimelineTab({required this.file, required this.times});
  final CaseFile file;
  final List<NotebookClue> times;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // Her satır bir güne ait: baştan bilinenler kendi gününe, fotoğraftan bulunanlar fotoğrafın tarihine.
    // Günler hikâyedeki sıraya göre (ilk göründükleri rulo/kare), gün içinde saate göre sıralanır.
    final days = <String, List<_Row>>{};
    final dayOrder = <String, int>{};
    for (final e in file.timeline) {
      final day = file.timelineDate;
      days
          .putIfAbsent(day, () => [])
          .add(_Row(e.tag, e.title, e.body, null, null));
      dayOrder[day] = dayOrder[day] ?? 0;
    }
    for (final c in times) {
      final day = file.frame(c.reel, c.frame)?.photo.date ?? '';
      days
          .putIfAbsent(day, () => [])
          .add(_Row(c.tag ?? '?', c.title, c.body, c.source, c));
      final key = c.reel * 100 + c.frame;
      final prev = dayOrder[day];
      dayOrder[day] = prev == null || key < prev ? key : prev;
    }
    final ordered = days.keys.toList()
      ..sort((a, b) => dayOrder[a]!.compareTo(dayOrder[b]!));

    return ListView(
      padding: const EdgeInsets.fromLTRB(
          KoSpacing.l, KoSpacing.l, KoSpacing.l, KoSpacing.xxl),
      children: [
        for (final day in ordered) ...[
          Text(
            (day == file.timelineDate && file.timelineTitle.isNotEmpty
                    ? file.timelineTitle
                    : day)
                .toUpperCase(),
            style: KoText.label.copyWith(color: KoColor.redText),
          ),
          const SizedBox(height: KoSpacing.m),
          ..._rows(context, days[day]!..sort((a, b) => a.tag.compareTo(b.tag))),
          const SizedBox(height: KoSpacing.m),
        ],
        Text(
          times.isEmpty ? l10n.notebookNoTimes : l10n.notebookTimelineHint,
          style: KoText.bodySmall
              .copyWith(color: KoColor.textDim, fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  List<Widget> _rows(BuildContext context, List<_Row> rows) {
    final l10n = context.l10n;
    return [
      for (var i = 0; i < rows.length; i++)
        InkWell(
          onTap: rows[i].clue == null
              ? null
              : () => _showPhoto(context, rows[i].clue!),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 52,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Text(rows[i].tag,
                        style: KoText.hintCount.copyWith(fontSize: 14)),
                  ),
                ),
                // Dikey çizgi ve nokta
                SizedBox(
                  width: 22,
                  child: Column(
                    children: [
                      const SizedBox(height: 4),
                      Container(
                        width: 11,
                        height: 11,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: rows[i].clue == null
                              ? KoColor.safelight
                              : KoColor.amber,
                        ),
                      ),
                      if (i < rows.length - 1)
                        Expanded(
                            child:
                                Container(width: 2, color: KoColor.lineStrong)),
                    ],
                  ),
                ),
                const SizedBox(width: KoSpacing.s),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: KoSpacing.xl),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(rows[i].title,
                            style: KoText.cardTitle.copyWith(fontSize: 16)),
                        const SizedBox(height: 2),
                        Text(rows[i].body,
                            style: KoText.body.copyWith(fontSize: 13)),
                        const SizedBox(height: 4),
                        Text(
                          rows[i].source ?? l10n.notebookKnownFact,
                          style: KoText.counter
                              .copyWith(fontSize: 11, color: KoColor.textDim),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    ];
  }
}

class _Row {
  const _Row(this.tag, this.title, this.body, this.source, this.clue);
  final String tag;
  final String title;
  final String body;
  final String? source;
  final NotebookClue? clue;
}

// ---------------------------------------------------------------- Teoriler

class _TheoriesTab extends StatelessWidget {
  const _TheoriesTab({required this.file, required this.progress});
  final CaseFile file;
  final CaseProgress progress;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // Henüz gelinmemiş rulonun sorusu gösterilmez (hikâyeyi ele verir).
    final reels = file.reels
        .where((r) => r.question != null && r.number <= progress.reel)
        .toList();
    final decision = file.finale?.option(progress.ending);
    return ListView(
      padding: const EdgeInsets.all(KoSpacing.l),
      children: [
        for (final r in reels) ...[
          Builder(builder: (context) {
            final q = r.question!;
            final answerId = progress.theories[r.number];
            String? answer;
            for (final o in q.options) {
              if (o.id == answerId) answer = o.text;
            }
            return _Card(
              dim: answer == null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.notebookTheoryLabel(r.number),
                      style: KoText.label.copyWith(color: KoColor.redText)),
                  const SizedBox(height: KoSpacing.xs),
                  if (answer != null) ...[
                    Text(q.text,
                        style: KoText.cardTitle.copyWith(fontSize: 16)),
                    const SizedBox(height: KoSpacing.s),
                  ],
                  if (answer != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: KoSpacing.m, vertical: KoSpacing.s),
                      decoration: BoxDecoration(
                          color: KoColor.paper,
                          borderRadius: BorderRadius.circular(KoRadius.small)),
                      child: Text(answer,
                          style: KoText.handwriting.copyWith(fontSize: 21)),
                    )
                  else
                    Text(l10n.notebookTheoryPending(r.number),
                        style: KoText.bodySmall),
                ],
              ),
            );
          }),
          const SizedBox(height: KoSpacing.s),
        ],
        if (decision != null) ...[
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.notebookDecisionLabel,
                    style: KoText.label.copyWith(color: KoColor.redText)),
                const SizedBox(height: KoSpacing.xs),
                Text(file.finale!.question,
                    style: KoText.cardTitle.copyWith(fontSize: 16)),
                const SizedBox(height: KoSpacing.s),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: KoSpacing.m, vertical: KoSpacing.s),
                  decoration: BoxDecoration(
                      color: KoColor.paper,
                      borderRadius: BorderRadius.circular(KoRadius.small)),
                  child: Text(decision.text,
                      style: KoText.handwriting.copyWith(fontSize: 21)),
                ),
              ],
            ),
          ),
          const SizedBox(height: KoSpacing.s),
        ],
        const SizedBox(height: KoSpacing.s),
        Text(l10n.notebookTheoryHint,
            style: KoText.bodySmall
                .copyWith(color: KoColor.textDim, fontStyle: FontStyle.italic)),
      ],
    );
  }
}

// ---------------------------------------------------------------- Ortak

class _Card extends StatelessWidget {
  const _Card({super.key, required this.child, this.onTap, this.dim = false});
  final Widget child;
  final VoidCallback? onTap;
  final bool dim;

  @override
  Widget build(BuildContext context) => Opacity(
        opacity: dim ? 0.55 : 1,
        child: Material(
          color: KoColor.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(KoRadius.card),
            side: const BorderSide(color: KoColor.line),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
                padding: const EdgeInsets.all(KoSpacing.m + 2), child: child),
          ),
        ),
      );
}

class _TagChip extends StatelessWidget {
  const _TagChip(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
        decoration: BoxDecoration(
            color: KoColor.paper,
            borderRadius: BorderRadius.circular(KoRadius.small)),
        child: Text(text,
            style: KoText.bigNumber.copyWith(fontSize: 16, color: KoColor.ink)),
      );
}

class _EmptyTab extends StatelessWidget {
  const _EmptyTab({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(KoSpacing.xxl),
          child: Text(text,
              style: KoText.body.copyWith(color: KoColor.textMuted),
              textAlign: TextAlign.center),
        ),
      );
}

/// İpucunun geldiği fotoğrafı büyük gösterir.
void _showPhoto(BuildContext context, NotebookClue clue) {
  final container = ProviderScope.containerOf(context, listen: false);
  final frame = container
      .read(contentRepositoryProvider)
      .frame(clue.caseId, clue.reel, clue.frame);
  if (frame == null) return;
  final l10n = context.l10n;
  final width = MediaQuery.sizeOf(context).width * 0.78;
  showDialog<void>(
    context: context,
    barrierColor: const Color(0xE6000000),
    builder: (context) => GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              KoPhoto(
                  asset: frame.photo.asset,
                  width: width.clamp(200.0, 360.0),
                  semanticLabel: frame.photo.title),
              const SizedBox(height: KoSpacing.l),
              Text(frame.photo.title, style: KoText.cardTitle),
              Text('${clue.source} · ${frame.photo.date}',
                  style: KoText.counter),
              const SizedBox(height: KoSpacing.s),
              Text(l10n.notebookTapToClose,
                  style: KoText.bodySmall.copyWith(color: KoColor.textDim)),
            ],
          ),
        ),
      ),
    ),
  );
}

/// 35 · Hiç dosya açılmamış hali.
class _EmptyNotebook extends StatelessWidget {
  const _EmptyNotebook();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            KoSpacing.xl, KoSpacing.xxl, KoSpacing.xl, KoSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.notebookEyebrow, style: KoText.label),
            const SizedBox(height: 2),
            Text(context.l10n.notebookTitle, style: KoText.screenTitle),
            const Spacer(),
            Center(
                child: Text(context.l10n.notebookEmptyTitle,
                    style: KoText.sectionTitle)),
            const SizedBox(height: KoSpacing.s),
            Text(
              context.l10n.notebookEmptyBody,
              style: KoText.body.copyWith(color: KoColor.textMuted),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            KoButton(
                label: context.l10n.goToCaseFiles,
                onPressed: () => context.go(Routes.caseFiles)),
          ],
        ),
      ),
    );
  }
}
