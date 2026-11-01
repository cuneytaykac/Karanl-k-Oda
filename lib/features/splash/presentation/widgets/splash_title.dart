import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../l10n/l10n.dart';

/// "KARANLIK ODA" ve alt yazı. [title] ve [tagline] 0–1 arası belirme oranı.
class SplashTitle extends StatelessWidget {
  const SplashTitle({super.key, required this.title, required this.tagline});

  final double title;
  final double tagline;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Opacity(
          opacity: title,
          child: Text.rich(
            TextSpan(
              // Harfler aralıklı başlar, yerine otururken sıklaşır.
              style: KoText.display
                  .copyWith(fontSize: 30, letterSpacing: 2 + 10 * (1 - title)),
              children: [
                TextSpan(text: l10n.brandDark),
                TextSpan(
                    text: l10n.brandRoom,
                    style: const TextStyle(color: KoColor.redText)),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: KoSpacing.s),
        Opacity(
          opacity: tagline,
          child: Text(
            l10n.splashTagline,
            style:
                KoText.quote.copyWith(fontSize: 15, color: KoColor.textMuted),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
