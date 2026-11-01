import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../content/domain/entities/photo_spec.dart';

/// Bulunan ayrıntı: kâğıt kart, varsa saat/etiket kutusuyla.
class ClueCard extends StatelessWidget {
  const ClueCard({super.key, required this.hotspot, this.compact = false});
  final Hotspot hotspot;
  final bool compact;

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(compact ? KoSpacing.s + 2 : KoSpacing.m + 2),
        decoration: BoxDecoration(
            color: KoColor.paper,
            borderRadius: BorderRadius.circular(KoRadius.card)),
        child: Row(
          children: [
            if (hotspot.tag != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                decoration: BoxDecoration(
                    color: KoColor.ink,
                    borderRadius: BorderRadius.circular(KoRadius.small)),
                child: Text(hotspot.tag!,
                    style: KoText.bigNumber
                        .copyWith(fontSize: 18, color: KoColor.paper)),
              ),
              const SizedBox(width: KoSpacing.m),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(hotspot.title,
                      style: KoText.cardTitle
                          .copyWith(color: KoColor.ink, fontSize: 16)),
                  const SizedBox(height: 2),
                  Text(
                    hotspot.body,
                    maxLines: compact ? 2 : null,
                    overflow: compact ? TextOverflow.ellipsis : null,
                    style: KoText.bodySmall.copyWith(color: KoColor.inkMuted),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
