import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/ko_photo.dart';
import '../../../content/domain/entities/case_file.dart';

/// Tek bir hikâye satırı: anlatıcı, konuşan kişi, gazete kâğıdı ya da mektup.
class StoryLine extends StatelessWidget {
  const StoryLine(
      {super.key, required this.line, this.file, this.compact = false});
  final IntroLine line;
  final CaseFile? file;

  /// İnceleme ekranındaki küçük tepki kartı için.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    switch (line.style) {
      case LineStyle.paper:
        return Container(
          padding: const EdgeInsets.all(KoSpacing.l),
          decoration: BoxDecoration(
              color: KoColor.paper,
              borderRadius: BorderRadius.circular(KoRadius.small)),
          child: Text(line.text,
              style: KoText.quote.copyWith(
                  color: KoColor.ink,
                  fontStyle: FontStyle.normal,
                  fontSize: 15)),
        );
      case LineStyle.letter:
        return Transform.rotate(
          angle: -0.012,
          child: Container(
            padding: const EdgeInsets.fromLTRB(
                KoSpacing.l, KoSpacing.m, KoSpacing.l, KoSpacing.m),
            decoration: BoxDecoration(
                color: KoColor.paper,
                borderRadius: BorderRadius.circular(KoRadius.small)),
            child: Text(line.text,
                style: KoText.handwriting.copyWith(fontSize: 23)),
          ),
        );
      case LineStyle.photo:
        final image = line.image;
        if (image == null) break;
        return Column(
          children: [
            // Banyo edilir gibi: karanlıktan yavaşça belirir.
            KoPhoto(
                    asset: image,
                    width: 230,
                    tilt: -0.025,
                    semanticLabel: line.text)
                .animate()
                .fadeIn(duration: 1600.ms, curve: Curves.easeIn)
                .scale(
                    begin: const Offset(0.96, 0.96),
                    end: const Offset(1, 1),
                    duration: 1600.ms),
            const SizedBox(height: KoSpacing.l),
            Text(line.text,
                    style: KoText.counter.copyWith(color: KoColor.textMuted),
                    textAlign: TextAlign.center)
                .animate()
                .fadeIn(delay: 1200.ms, duration: 600.ms),
          ],
        );
      case LineStyle.plain:
        break;
    }

    final s = line.speaker == null ? null : file?.person(line.speaker!);
    if (s == null) {
      final narration = Text(line.text,
          style: KoText.story
              .copyWith(fontStyle: FontStyle.italic, color: KoColor.textCream));
      final cue = _cueIcon(line.sfx);
      if (cue == null || compact) return narration;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [cue, const SizedBox(height: KoSpacing.s), narration],
      );
    }
    final avatar = compact ? 30.0 : 36.0;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: avatar,
          height: avatar,
          alignment: Alignment.center,
          decoration:
              const BoxDecoration(color: KoColor.paper, shape: BoxShape.circle),
          child: Text(s.initial,
              style: KoText.cardTitle
                  .copyWith(color: KoColor.ink, fontSize: compact ? 14 : 16)),
        ),
        SizedBox(width: compact ? KoSpacing.s + 2 : KoSpacing.m),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s.name,
                  style: KoText.bodySmall.copyWith(
                      color: KoColor.textMuted,
                      fontSize: compact ? 11.5 : null)),
              const SizedBox(height: 2),
              Text(
                '“${line.text}”',
                style: compact
                    ? KoText.quote.copyWith(fontSize: 14.5, color: KoColor.text)
                    : KoText.story,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Sesli anlatım satırlarının küçük simgesi: çalan telefon, sallanan zil.
Widget? _cueIcon(String? sfx) {
  switch (sfx) {
    case 'phone':
      return const Icon(Icons.phone_rounded, color: KoColor.amber, size: 30)
          .animate()
          // Sesle aynı ritim: 1,4 sn çalar, 0,9 sn susar, yine çalar.
          .shake(hz: 9, rotation: 0.12, duration: 1400.ms)
          .then(delay: 900.ms)
          .shake(hz: 9, rotation: 0.12, duration: 1400.ms);
    case 'mobile':
      return const Icon(Icons.smartphone_rounded,
              color: KoColor.amber, size: 30)
          .animate()
          // Ses gibi: iki titreşim, sonra zil.
          .shake(
              hz: 14, offset: const Offset(3, 0), rotation: 0, duration: 450.ms)
          .then(delay: 150.ms)
          .shake(
              hz: 14, offset: const Offset(3, 0), rotation: 0, duration: 450.ms)
          .then(delay: 250.ms)
          .shake(hz: 6, rotation: 0.08, duration: 1500.ms);
    case 'message':
      return const Icon(Icons.mark_chat_unread_rounded,
              color: KoColor.amber, size: 28)
          .animate()
          .fadeIn(duration: 200.ms)
          .scale(
              begin: const Offset(0.6, 0.6),
              end: const Offset(1, 1),
              duration: 400.ms,
              curve: Curves.easeOutBack);
    case 'doorbell':
      return const Icon(Icons.notifications_rounded,
              color: KoColor.amber, size: 28)
          .animate()
          .shake(
              hz: 4, rotation: 0.25, duration: 1200.ms, curve: Curves.easeOut);
    default:
      return null;
  }
}
