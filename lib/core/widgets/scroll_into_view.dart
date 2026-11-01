import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Ekrana ilk geldiğinde içinde bulunduğu kaydırma alanını kendine kaydırır
/// (örn. seçimden sonra açılan satırlar görünür olsun). Durumsuzdur.
class ScrollIntoView extends StatelessWidget {
  const ScrollIntoView({
    super.key,
    this.child = const SizedBox.shrink(),
    this.duration = const Duration(milliseconds: 500),
  });

  final Widget child;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => child.animate(
        onPlay: (_) {
          if (!context.mounted) return;
          Scrollable.ensureVisible(context,
              alignment: 1, duration: duration, curve: Curves.easeOut);
        },
      ),
    );
  }
}
