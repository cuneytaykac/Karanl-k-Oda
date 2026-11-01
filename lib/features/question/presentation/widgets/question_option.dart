import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';

/// Teori seçeneği: seçilince kâğıt rengine döner, ötekiler soluklaşır.
class QuestionOption extends StatelessWidget {
  const QuestionOption(
      {super.key,
      required this.text,
      required this.selected,
      required this.dimmed,
      this.onTap});
  final String text;
  final bool selected;
  final bool dimmed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: dimmed ? 0.4 : 1,
      child: Material(
        color: selected ? KoColor.paper : KoColor.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(KoRadius.button),
          side:
              BorderSide(color: selected ? KoColor.paper : KoColor.lineStrong),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: KoSize.buttonTall),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: KoSpacing.l, vertical: KoSpacing.m),
              child: Row(
                children: [
                  Icon(
                    selected
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_unchecked_rounded,
                    size: 20,
                    color: selected ? KoColor.paperLabel : KoColor.textDim,
                  ),
                  const SizedBox(width: KoSpacing.m),
                  Expanded(
                    child: Text(
                      text,
                      style: KoText.body.copyWith(
                        fontSize: 15,
                        color: selected ? KoColor.ink : KoColor.text,
                        fontWeight:
                            selected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
