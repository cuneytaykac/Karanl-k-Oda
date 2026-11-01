import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/ko_button.dart';
import '../../../../core/widgets/ko_icon_button.dart';
import '../../../../core/widgets/ko_photo.dart';
import '../../../../l10n/l10n.dart';

/// Banyo edilmiş fotoğraf.
/// GEÇİCİ: Aşama 1 · 4. adımda bu ekran "Fotoğrafı incele" (23) olacak:
/// büyüteç, ayrıntı noktaları ve "Deftere ekle".
class PhotoScreen extends StatelessWidget {
  const PhotoScreen({
    super.key,
    required this.photoAsset,
    required this.reel,
    required this.frame,
    required this.onClose,
  });

  final String photoAsset;
  final int reel;
  final int frame;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              KoSpacing.l, KoSpacing.m, KoSpacing.l, KoSpacing.xxl),
          child: Column(
            children: [
              Row(
                children: [
                  KoIconButton(
                      icon: Icons.chevron_left,
                      label: l10n.puzzleBackLabel,
                      onPressed: onClose),
                  Expanded(
                    child: Text(l10n.puzzleTitle(reel, frame),
                        style: KoText.cardTitle, textAlign: TextAlign.center),
                  ),
                  const SizedBox(width: KoSize.iconButton),
                ],
              ),
              Expanded(
                child: Center(
                  child: KoPhoto(
                    key: const Key('developed-photo'),
                    asset: photoAsset,
                    width: (width * 0.78).clamp(220.0, 340.0),
                    semanticLabel: l10n.developedPhotoLabel,
                  ),
                ),
              ),
              KoButton(label: l10n.done, onPressed: onClose),
            ],
          ),
        ),
      ),
    );
  }
}
