import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/ko_button.dart';
import '../../../../core/widgets/ko_icon_button.dart';
import '../../../../l10n/l10n.dart';
import '../view_model/inspect_view_model.dart';
import '../widgets/clue_card.dart';
import '../widgets/hint_card.dart';
import '../widgets/loupe_photo.dart';

/// 23 · Fotoğrafı incele: büyüteçle ayrıntıyı bul, deftere ekle, sonraki kareye geç.
/// Mantık [InspectViewModel]'de; bu ekran yalnızca çizer.
class InspectScreen extends ConsumerWidget {
  const InspectScreen({
    super.key,
    required this.caseId,
    required this.reel,
    required this.frame,
    required this.onNext,
    required this.onClose,
    this.reaction,
    this.search = true,
  });

  final String caseId;
  final int reel;
  final int frame;

  /// Sonraki kareye geç (Deftere ekle ya da Şimdilik geç).
  final VoidCallback onNext;

  /// Geri: Banyo sekmesine dön.
  final VoidCallback onClose;

  /// İpucu bulununca ipucu kartının altında beliren kısa söz (ör. Ayşe'nin tepkisi).
  final Widget? reaction;

  /// true: oyuncu ayrıntıyı kendisi arar. false: ayrıntı baştan işaretli gelir.
  final bool search;

  InspectArgs get _args =>
      (caseId: caseId, reel: reel, frame: frame, search: search);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(inspectViewModelProvider(_args));
    final vm = ref.read(inspectViewModelProvider(_args).notifier);
    final spec = state.spec;
    final hotspots = state.hotspots;
    final revealed = state.showsClues;
    final inNotebook = revealed && ref.watch(inspectInNotebookProvider(_args));

    // Fotoğraf: ekran genişliğinin %84'ü, ama yükseklik ekranın yarısını geçmesin.
    // Birden çok ipucu kartı varsa fotoğraf biraz küçülür.
    final size = MediaQuery.sizeOf(context);
    final heightShare = revealed && hotspots.length > 1 ? 0.4 : 0.5;
    final photoW = [size.width * 0.84, size.height * heightShare * 3 / 4, 340.0]
        .reduce((a, b) => a < b ? a : b);

    void addAndNext() {
      vm.addToNotebook();
      onNext();
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              KoSpacing.l, KoSpacing.m, KoSpacing.l, KoSpacing.xl),
          child: Column(
            children: [
              Row(
                children: [
                  KoIconButton(
                      icon: Icons.chevron_left,
                      label: l10n.puzzleBackLabel,
                      onPressed: onClose),
                  Expanded(
                    child: Column(
                      children: [
                        Text(spec.title,
                            style: KoText.cardTitle,
                            textAlign: TextAlign.center),
                        Text(
                          '${l10n.puzzleTitle(reel, frame)} · ${spec.date}',
                          style: KoText.counter,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: KoSize.iconButton),
                ],
              ),
              Expanded(
                child: Center(
                  child: LoupePhoto(
                    spec: spec,
                    width: photoW,
                    loupe: state.loupe,
                    highlight: revealed,
                    marks: revealed || state.nudge ? hotspots : const [],
                    pulseMarks: state.nudge && !revealed,
                    onProbe: vm.probe,
                    semanticLabel: l10n.inspectPhotoLabel,
                  ),
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: !revealed
                    ? HintCard(
                        key: const ValueKey('hint'),
                        text:
                            state.nudge ? l10n.inspectNudge : l10n.inspectHint)
                    : Column(
                        key: const ValueKey('clue'),
                        children: [
                          for (var i = 0; i < hotspots.length; i++) ...[
                            if (i > 0) const SizedBox(height: KoSpacing.s),
                            ClueCard(
                                hotspot: hotspots[i],
                                compact: hotspots.length > 1),
                          ],
                        ],
                      ),
              ),
              if (revealed && reaction != null)
                Padding(
                  key: const Key('inspect-reaction'),
                  padding: const EdgeInsets.fromLTRB(
                      KoSpacing.xs, KoSpacing.m, KoSpacing.xs, 0),
                  child: reaction!
                      .animate()
                      .fadeIn(delay: 350.ms, duration: 400.ms)
                      .slideY(
                          begin: 0.15,
                          end: 0,
                          delay: 350.ms,
                          duration: 400.ms,
                          curve: Curves.easeOut),
                ),
              const SizedBox(height: KoSpacing.m),
              if (!revealed)
                TextButton(
                  key: const Key('inspect-skip'),
                  // İpucu varsa göster (hikâye kaçmasın); yoksa doğrudan devam.
                  onPressed: hotspots.isEmpty ? onNext : vm.reveal,
                  style: TextButton.styleFrom(
                      minimumSize: const Size.fromHeight(44),
                      foregroundColor: KoColor.textDim),
                  child: Text(
                      hotspots.isEmpty ? l10n.inspectSkip : l10n.inspectReveal,
                      style:
                          KoText.buttonSmall.copyWith(color: KoColor.textDim)),
                )
              else
                KoButton(
                  key: const Key('inspect-add'),
                  label: inNotebook
                      ? l10n.inspectNextFrame(frame + 1)
                      : l10n.inspectAddToNotebook(frame + 1),
                  icon: inNotebook
                      ? Icons.arrow_forward_rounded
                      : Icons.edit_note_rounded,
                  onPressed: addAndNext,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
