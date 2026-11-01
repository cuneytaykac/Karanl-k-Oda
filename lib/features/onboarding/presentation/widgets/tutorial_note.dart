import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';

/// Nermin Hanım'ın notu: el yazısı, kâğıt üstünde. Adım değişince yumuşakça yenilenir.
class TutorialNote extends StatelessWidget {
  const TutorialNote({
    super.key,
    required this.step,
    required this.label,
    required this.text,
  });

  final int step;
  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      child: Container(
        key: ValueKey(step),
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(
            KoSpacing.l, KoSpacing.m, KoSpacing.l, KoSpacing.m),
        decoration: BoxDecoration(
            color: KoColor.paper,
            borderRadius: BorderRadius.circular(KoRadius.small)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: KoText.label.copyWith(color: KoColor.paperLabel)),
            const SizedBox(height: 4),
            Text(text, style: KoText.handwriting.copyWith(fontSize: 21)),
          ],
        ),
      ),
    );
  }
}
