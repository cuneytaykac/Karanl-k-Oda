import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../theme/theme.dart';

/// Kanvastaki "Nav" bileşeni: Banyo · Dosyalar · Defter.
/// Bulmaca, banyo animasyonu ve final ekranlarında gösterilmez.
class BottomNav extends StatelessWidget {
  const BottomNav(
      {super.key,
      required this.selected,
      required this.onSelected,
      this.notebookDot = false});

  final int selected;
  final ValueChanged<int> onSelected;

  /// Defterde okunmamış yeni ipucu varsa kırmızı nokta.
  final bool notebookDot;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final items = [
      (icon: Icons.emoji_objects_outlined, label: l10n.navDeveloping),
      (icon: Icons.folder_outlined, label: l10n.navCaseFiles),
      (icon: Icons.menu_book_outlined, label: l10n.navNotebook),
    ];
    return Container(
      decoration: const BoxDecoration(
        color: KoColor.bottomNav,
        border: Border(top: BorderSide(color: KoColor.line)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: _NavItem(
                    icon: items[i].icon,
                    label: items[i].label,
                    active: i == selected,
                    dot: i == 2 && notebookDot,
                    onTap: () => onSelected(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem(
      {required this.icon,
      required this.label,
      required this.active,
      required this.dot,
      required this.onTap});

  final IconData icon;
  final String label;
  final bool active;
  final bool dot;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? KoColor.redText : KoColor.textMuted;
    return Semantics(
      selected: active,
      button: true,
      label: label,
      child: InkResponse(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, color: color, size: 24),
                if (dot)
                  const Positioned(
                    right: -4,
                    top: -2,
                    child: CircleAvatar(
                        radius: 4, backgroundColor: KoColor.safelight),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Text(label,
                style: KoText.bottomNav.copyWith(
                    color: color,
                    fontWeight: active ? FontWeight.w600 : FontWeight.w400)),
          ],
        ),
      ),
    );
  }
}
