import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';

/// Arama karesinde yönlendirme: ne aranacağı ya da (takılınca) yerin parladığı.
class HintCard extends StatelessWidget {
  const HintCard({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(KoSpacing.m + 2),
        decoration: BoxDecoration(
          color: KoColor.surface,
          borderRadius: BorderRadius.circular(KoRadius.card),
          border: Border.all(color: KoColor.line),
        ),
        child: Row(
          children: [
            const Icon(Icons.search_rounded, color: KoColor.amber),
            const SizedBox(width: KoSpacing.m),
            Expanded(
                child: Text(text, style: KoText.body.copyWith(fontSize: 13.5))),
          ],
        ),
      );
}
