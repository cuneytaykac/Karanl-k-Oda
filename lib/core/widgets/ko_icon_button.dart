import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// 44×44 kare ikon düğmesi (geri, ayarlar, menü, defter).
class KoIconButton extends StatelessWidget {
  const KoIconButton(
      {super.key,
      required this.icon,
      required this.label,
      required this.onPressed,
      this.filled = true});

  final IconData icon;
  final String label; // ekran okuyucu için
  final VoidCallback onPressed;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: filled ? KoColor.surface : Colors.transparent,
        borderRadius: BorderRadius.circular(KoRadius.icon),
        child: InkWell(
          borderRadius: BorderRadius.circular(KoRadius.icon),
          onTap: onPressed,
          child: SizedBox.square(
            dimension: KoSize.iconButton,
            child: Icon(icon,
                size: 20, color: filled ? KoColor.text : KoColor.textMuted),
          ),
        ),
      ),
    );
  }
}
