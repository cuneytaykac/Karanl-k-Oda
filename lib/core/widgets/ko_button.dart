import 'package:flutter/material.dart';

import '../theme/theme.dart';

enum KoButtonKind { primary, ghost }

/// Uygulamanın tek düğmesi.
/// birincil: kırmızı, ekrandaki ana eylem (her ekranda en fazla bir tane).
/// hayalet: kenarlıklı, ikincil eylem.
class KoButton extends StatelessWidget {
  const KoButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.kind = KoButtonKind.primary,
    this.icon,
  });

  const KoButton.ghost(
      {super.key, required this.label, required this.onPressed, this.icon})
      : kind = KoButtonKind.ghost;

  final String label;
  final VoidCallback? onPressed; // null ise pasif
  final KoButtonKind kind;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final primary = kind == KoButtonKind.primary;
    final disabled = onPressed == null;
    final background = primary
        ? (disabled ? KoColor.line : KoColor.redButton)
        : Colors.transparent;
    final textColor = disabled
        ? KoColor.textDisabled
        : (primary ? KoColor.redButtonText : KoColor.text);

    return SizedBox(
      width: double.infinity,
      height: primary ? KoSize.buttonTall : KoSize.buttonMedium,
      child: Material(
        color: background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(KoRadius.button),
          side: primary
              ? BorderSide.none
              : const BorderSide(color: KoColor.ghostBorder),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: textColor),
                const SizedBox(width: KoSpacing.s)
              ],
              // Uzun etiket ya da büyük yazı ayarında taşmak yerine küçülür.
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: KoSpacing.s),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label,
                      maxLines: 1,
                      style: (primary
                              ? KoText.button
                              : KoText.buttonSmall.copyWith(fontSize: 15))
                          .copyWith(color: textColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
