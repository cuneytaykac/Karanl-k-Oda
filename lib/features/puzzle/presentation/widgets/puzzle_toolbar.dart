import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../domain/nonogram/cell_state.dart';

/// Doldur / İşaretle seçici + Geri al · İpucu · Temizle.
class PuzzleToolbar extends StatelessWidget {
  const PuzzleToolbar({
    super.key,
    required this.tool,
    required this.onTool,
    required this.fillLabel,
    required this.crossLabel,
    required this.undoLabel,
    required this.hintLabel,
    required this.clearLabel,
    required this.onUndo,
    required this.onHint,
    required this.onClear,
    required this.hintAccent,
    this.hintIcon = Icons.lightbulb_outline_rounded,
  });

  final Tool tool;
  final ValueChanged<Tool> onTool;
  final String fillLabel, crossLabel, undoLabel, hintLabel, clearLabel;
  final VoidCallback? onUndo; // null = pasif
  final VoidCallback? onHint; // null = pasif (örn. reklam açılıyor)
  final VoidCallback? onClear;

  /// İpucu kullanılabilir: düğme kehribar renkte öne çıkar.
  final bool hintAccent;

  /// Hak bitince reklam simgesine döner.
  final IconData hintIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: KoColor.surface,
              borderRadius: BorderRadius.circular(KoRadius.button)),
          child: Row(
            children: [
              _ToolTab(
                  label: '■  $fillLabel',
                  selected: tool == Tool.fill,
                  onTap: () => onTool(Tool.fill)),
              const SizedBox(width: 4),
              _ToolTab(
                  label: '×  $crossLabel',
                  selected: tool == Tool.cross,
                  onTap: () => onTool(Tool.cross)),
            ],
          ),
        ),
        const SizedBox(height: KoSpacing.s),
        Row(
          children: [
            _Action(icon: Icons.undo_rounded, label: undoLabel, onTap: onUndo),
            const SizedBox(width: KoSpacing.s),
            _Action(
              icon: hintIcon,
              label: hintLabel,
              onTap: onHint,
              accent: hintAccent,
            ),
            const SizedBox(width: KoSpacing.s),
            _Action(
                icon: Icons.layers_clear_outlined,
                label: clearLabel,
                onTap: onClear),
          ],
        ),
      ],
    );
  }
}

class _ToolTab extends StatelessWidget {
  const _ToolTab(
      {required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        child: Material(
          color: selected ? KoColor.paper : Colors.transparent,
          borderRadius: BorderRadius.circular(KoRadius.medium),
          child: InkWell(
            borderRadius: BorderRadius.circular(KoRadius.medium),
            onTap: onTap,
            child: SizedBox(
              height: 48,
              child: Center(
                child: Text(
                  label,
                  style: KoText.buttonSmall.copyWith(
                    fontSize: 15,
                    color: selected ? KoColor.ink : KoColor.textMuted,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Action extends StatelessWidget {
  const _Action(
      {required this.icon,
      required this.label,
      required this.onTap,
      this.accent = false});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    final color = !enabled
        ? KoColor.textDisabled
        : (accent ? KoColor.amber : KoColor.text);
    return Expanded(
      child: Material(
        color: KoColor.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(KoRadius.icon),
          side: BorderSide(
              color: accent && enabled ? KoColor.amberBorder : KoColor.line),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(KoRadius.icon),
          onTap: onTap,
          child: SizedBox(
            height: 52,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: KoText.buttonSmall
                        .copyWith(fontSize: 13.5, color: color),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
