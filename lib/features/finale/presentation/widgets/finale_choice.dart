import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../content/domain/entities/case_file.dart';

/// Son karar seçeneği: başlık ve ne anlama geldiği.
class FinaleChoice extends StatelessWidget {
  const FinaleChoice(
      {super.key,
      required this.option,
      required this.selected,
      required this.onTap});
  final FinaleOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? KoColor.paper : KoColor.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(KoRadius.card),
        side: BorderSide(
            color: selected ? KoColor.paper : KoColor.lineStrong,
            width: selected ? 2 : 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(KoSpacing.l),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                selected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: selected ? KoColor.paperLabel : KoColor.textDim,
              ),
              const SizedBox(width: KoSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(option.text,
                        style: KoText.cardTitle.copyWith(
                            color: selected ? KoColor.ink : KoColor.text)),
                    const SizedBox(height: 4),
                    Text(option.detail,
                        style: KoText.body.copyWith(
                            fontSize: 13,
                            color: selected
                                ? KoColor.inkMuted
                                : KoColor.textMuted)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
