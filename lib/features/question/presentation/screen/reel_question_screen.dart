import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/ko_button.dart';
import '../../../../core/widgets/ko_icon_button.dart';
import '../../../../core/widgets/scroll_into_view.dart';
import '../../../../l10n/l10n.dart';
import '../../../content/domain/entities/case_file.dart';
import '../../../story/presentation/widgets/story_line.dart';
import '../view_model/reel_question_view_model.dart';
import '../widgets/question_option.dart';

/// 26 · Rulo sonu sorusu: oyuncu teorisini seçer. Doğru cevap şimdi söylenmez;
/// sonraki rulolar gösterir. Seçimden sonra tepki ve kapanış satırları gelir.
class ReelQuestionScreen extends ConsumerWidget {
  const ReelQuestionScreen({
    super.key,
    required this.file,
    required this.reel,
    required this.question,
    required this.onDone,
    required this.onBack,
    required this.doneLabel,
  });

  final CaseFile file;
  final int reel;
  final ReelQuestion question;
  final VoidCallback onDone;
  final VoidCallback onBack;
  final String doneLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider =
        reelQuestionViewModelProvider((caseId: file.id, reel: reel));
    final l10n = context.l10n;
    final q = question;
    final chosen = ref.watch(provider);
    final vm = ref.read(provider.notifier);
    final reply = chosen == null ? null : q.replies[chosen];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  KoSpacing.m, KoSpacing.m, KoSpacing.l, 0),
              child: Row(
                children: [
                  KoIconButton(
                      icon: Icons.chevron_left,
                      label: l10n.back,
                      onPressed: onBack),
                  const SizedBox(width: KoSpacing.m),
                  Expanded(
                    child: Text(
                      l10n.questionEyebrow(reel),
                      style: KoText.label.copyWith(color: KoColor.redText),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                    KoSpacing.xl, KoSpacing.xxl, KoSpacing.xl, KoSpacing.xl),
                children: [
                  Text(q.text, style: KoText.sectionTitle),
                  const SizedBox(height: KoSpacing.s),
                  Text(l10n.questionHint,
                      style: KoText.bodySmall.copyWith(color: KoColor.textDim)),
                  const SizedBox(height: KoSpacing.xl),
                  for (final o in q.options) ...[
                    QuestionOption(
                      key: Key('option-${o.id}'),
                      text: o.text,
                      selected: chosen == o.id,
                      dimmed: chosen != null && chosen != o.id,
                      onTap: chosen == null ? () => vm.choose(o.id) : null,
                    ),
                    const SizedBox(height: KoSpacing.s),
                  ],
                  if (chosen != null) ...[
                    const SizedBox(height: KoSpacing.l),
                    Row(
                      children: [
                        const Icon(Icons.edit_note_rounded,
                            color: KoColor.amber, size: 20),
                        const SizedBox(width: KoSpacing.s),
                        Expanded(
                            child: Text(l10n.questionSaved,
                                style: KoText.bodySmall
                                    .copyWith(color: KoColor.amber))),
                      ],
                    ).animate().fadeIn(duration: 300.ms),
                    const SizedBox(height: KoSpacing.xl),
                    if (reply != null)
                      StoryLine(line: reply, file: file)
                          .animate()
                          .fadeIn(delay: 300.ms, duration: 500.ms),
                    for (var i = 0; i < q.outro.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(top: KoSpacing.xl),
                        child: StoryLine(line: q.outro[i], file: file)
                            .animate()
                            .fadeIn(
                                delay: ReelQuestionViewModel.outroDelay(i),
                                duration: 500.ms),
                      ),
                    // Seçimden sonra açılan satırlar görünsün.
                    const ScrollIntoView(),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  KoSpacing.l, 0, KoSpacing.l, KoSpacing.l),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: chosen == null
                    ? const SizedBox(height: KoSize.buttonTall)
                    : KoButton(
                        key: const Key('question-done'),
                        label: doneLabel,
                        onPressed: onDone),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
