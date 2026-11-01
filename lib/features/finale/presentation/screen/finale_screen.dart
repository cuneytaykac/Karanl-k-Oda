import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/ko_button.dart';
import '../../../../core/widgets/ko_icon_button.dart';
import '../../../../l10n/l10n.dart';
import '../../../content/domain/entities/case_file.dart';
import '../../../story/presentation/widgets/story_line.dart';
import '../view_model/finale_view_model.dart';
import '../widgets/finale_choice.dart';

/// Son karar: doğru cevabı yok. Seçime göre kapanış sahnesi gelir.
class FinaleScreen extends ConsumerWidget {
  const FinaleScreen({
    super.key,
    required this.file,
    required this.finale,
    required this.onConfirmed,
    required this.onBack,
  });

  final CaseFile file;
  final Finale finale;

  /// Karar kaydedildi: kapanışa geç.
  final VoidCallback onConfirmed;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final f = finale;
    final provider = finaleViewModelProvider(file.id);
    final selected = ref.watch(provider);
    final vm = ref.read(provider.notifier);

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
                    child: Text(f.eyebrow,
                        style: KoText.label.copyWith(color: KoColor.redText),
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                    KoSpacing.xl, KoSpacing.xxl, KoSpacing.xl, KoSpacing.xl),
                children: [
                  for (var i = 0; i < f.intro.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: KoSpacing.xl),
                      child: StoryLine(line: f.intro[i], file: file)
                          .animate()
                          .fadeIn(delay: (300 + 700 * i).ms, duration: 500.ms),
                    ),
                  Text(f.question, style: KoText.sectionTitle),
                  const SizedBox(height: KoSpacing.s),
                  Text(f.hint,
                      style: KoText.bodySmall.copyWith(color: KoColor.textDim)),
                  const SizedBox(height: KoSpacing.xl),
                  for (final o in f.options) ...[
                    FinaleChoice(
                      key: Key('finale-${o.id}'),
                      option: o,
                      selected: selected == o.id,
                      onTap: () => vm.select(o.id),
                    ),
                    const SizedBox(height: KoSpacing.m),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  KoSpacing.l, 0, KoSpacing.l, KoSpacing.l),
              child: KoButton(
                key: const Key('finale-confirm'),
                label: l10n.finaleConfirm,
                onPressed: selected == null
                    ? null
                    : () {
                        if (vm.confirm()) onConfirmed();
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
