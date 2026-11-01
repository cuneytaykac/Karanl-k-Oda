import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/ko_button.dart';
import '../../../../core/widgets/ko_icon_button.dart';
import '../../../../core/widgets/scroll_into_view.dart';
import '../../../../l10n/l10n.dart';
import '../../../content/domain/entities/case_file.dart';
import '../view_model/story_view_model.dart';
import '../widgets/story_line.dart';

/// Hikâye anları için ortak ekran: Dosya açılışı (15) ve kareler arası sahneler.
/// Satırlar tek tek gelir; ekrana dokundukça sonraki açılır. Son satırdan sonra düğme çıkar.
class StoryScreen extends ConsumerWidget {
  const StoryScreen({
    super.key,
    required this.storyId,
    required this.eyebrow,
    required this.lines,
    this.file,
    required this.doneLabel,
    required this.onDone,
    required this.onBack,
    this.title,
    this.showBack = true,
  });

  /// Bu hikâye anının kimliği (örn. "scene/wrong_man/2/4"). Hangi satırda kalındığı buna bağlıdır.
  final String storyId;
  final String eyebrow;
  final String? title;
  final List<IntroLine> lines;

  /// Konuşanların adını ve baş harfini bulmak için (ilk açılışta yok).
  final CaseFile? file;
  final String doneLabel;
  final VoidCallback onDone;
  final VoidCallback onBack;

  /// İlk açılışta false: geri düğmesi yok, telefonun geri hareketi de çalışmaz.
  final bool showBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final provider = storyViewModelProvider(StoryArgs(storyId, lines));
    final shown = ref.watch(provider);
    final vm = ref.read(provider.notifier);
    final allShown = shown >= lines.length;
    final title = this.title;

    return PopScope(
      canPop: showBack,
      child: Scaffold(
        body: SafeArea(
          child: GestureDetector(
            key: const Key('story-tap-area'),
            behavior: HitTestBehavior.opaque,
            onTap: vm.next,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      KoSpacing.m, KoSpacing.m, KoSpacing.l, 0),
                  child: Row(
                    children: [
                      if (showBack) ...[
                        KoIconButton(
                            icon: Icons.chevron_left,
                            label: l10n.back,
                            onPressed: onBack),
                        const SizedBox(width: KoSpacing.m),
                      ] else
                        const SizedBox(height: KoSize.iconButton),
                      Expanded(
                        child: Text(
                          eyebrow,
                          style: KoText.label.copyWith(color: KoColor.redText),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(KoSpacing.xl,
                        KoSpacing.xxl, KoSpacing.xl, KoSpacing.xxl),
                    children: [
                      if (title != null && title.isNotEmpty) ...[
                        Text(title, style: KoText.screenTitle),
                        const SizedBox(height: KoSpacing.xl),
                      ],
                      for (var i = 0; i < shown && i < lines.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: KoSpacing.xl),
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 400),
                            opacity: i == shown - 1 ? 1 : 0.55,
                            child: StoryLine(line: lines[i], file: file),
                          ),
                        ),
                      // Yeni satır görünsün diye alta kayar.
                      ScrollIntoView(
                          key: ValueKey('scroll-$shown'),
                          duration: const Duration(milliseconds: 300)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      KoSpacing.l, 0, KoSpacing.l, KoSpacing.l),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: allShown
                        ? KoButton(
                            key: const Key('story-done'),
                            label: doneLabel,
                            onPressed: onDone)
                        : SizedBox(
                            height: KoSize.buttonTall,
                            child: Center(
                              child: Text(
                                '${l10n.tapToContinue}  ·  $shown / ${lines.length}',
                                style: KoText.bodySmall
                                    .copyWith(color: KoColor.textDisabled),
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
