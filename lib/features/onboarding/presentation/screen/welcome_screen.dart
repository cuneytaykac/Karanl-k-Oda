import 'package:flutter/material.dart';

import '../../../../l10n/l10n.dart';
import '../../../content/domain/entities/case_file.dart';
import '../../../story/presentation/screen/story_screen.dart';

/// İlk açılış: Nermin Hanım'ın vasiyeti, dükkân, dolap ve tezgâhtaki not.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key, required this.onDone});
  final VoidCallback onDone;

  static const lines = [
    IntroLine(
        text: 'Geçen kış, kasabanın eski fotoğrafçısı Nermin Hanım öldü.'),
    IntroLine(text: 'Vasiyetinde senin adın geçiyor.'),
    IntroLine(
      style: LineStyle.letter,
      sfx: 'letter',
      text:
          'Karanlık Oda\'yı, çocukken bir kez gelip bana "Işık nereye gidiyor?" diye soran küçüğe bırakıyorum.',
    ),
    IntroLine(
        text:
            'Bir sabah anahtarı alıp kepengi kaldırıyorsun. İçerisi kimyasal kokuyor; tavanda kırmızı bir lamba.',
        sfx: 'doorbell'),
    IntroLine(
        text:
            'Arka tarafta bir dolap var. Kapağında el yazısıyla: "Teslim edilmeyenler." İçinde, sahibine hiç verilmemiş onlarca film.',
        sfx: 'bag'),
    IntroLine(text: 'Tezgâhta, senin için bırakılmış bir not duruyor.'),
    IntroLine(
      style: LineStyle.letter,
      sfx: 'letter',
      text:
          'Filmler banyo edilmeyi bekliyor. Ama önce negatif okumayı öğren. Kenardaki sayılar her şeyi söyler; gerisi sabır.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
