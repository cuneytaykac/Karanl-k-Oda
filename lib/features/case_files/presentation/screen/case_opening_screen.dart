import 'package:flutter/material.dart';

import '../../../../l10n/l10n.dart';
import '../../../content/domain/entities/case_file.dart';
import '../../../story/presentation/screen/story_screen.dart';

/// 15 · Dosya açılışı: torba, gazete ve Ayşe'nin anlattıkları.
class CaseOpeningScreen extends StatelessWidget {
  const CaseOpeningScreen(
      {super.key,
      required this.file,
      required this.onDone,
      required this.onBack});

  final CaseFile file;
  final VoidCallback onDone;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return StoryScreen(
      storyId: 'opening/${file.id}',
      eyebrow: '${l10n.caseNumber(file.number)} · ${file.title.toUpperCase()}',
      lines: file.intro,
      file: file,
      doneLabel: l10n.caseOpenBag,
      onDone: onDone,
      onBack: onBack,
    );
  }
}
