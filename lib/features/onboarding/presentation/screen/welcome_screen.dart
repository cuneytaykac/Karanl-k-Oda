import 'package:flutter/material.dart';

import '../../../../l10n/l10n.dart';
import '../../../content/domain/entities/case_file.dart';
import '../../../story/presentation/screen/story_screen.dart';

/// İlk açılış: Nermin Hanım'ın vasiyeti, dükkân, dolap ve tezgâhtaki not.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key, required this.onDone});
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final lines = [
      IntroLine(text: l10n.welcomeLine1),
      IntroLine(text: l10n.welcomeLine2),
      IntroLine(style: LineStyle.letter, sfx: 'letter', text: l10n.welcomeLine3),
      IntroLine(text: l10n.welcomeLine4, sfx: 'doorbell'),
      IntroLine(text: l10n.welcomeLine5, sfx: 'bag'),
      IntroLine(text: l10n.welcomeLine6),
      IntroLine(style: LineStyle.letter, sfx: 'letter', text: l10n.welcomeLine7),
    ];
    return StoryScreen(
      storyId: 'welcome',
      eyebrow: l10n.welcomeEyebrow,
      title: l10n.welcomeTitle,
      lines: lines,
      doneLabel: l10n.welcomeStart,
      onDone: onDone,
      // İlk açılış yalnızca ileri gider: geri düğmesi yok, geri hareketi kapalı.
      showBack: false,
      onBack: () {},
    );
  }
}
