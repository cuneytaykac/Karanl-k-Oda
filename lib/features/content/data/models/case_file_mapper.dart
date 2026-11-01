import 'dart:ui';

import '../../../puzzle/domain/nonogram/puzzle.dart';
import '../../domain/entities/case_file.dart';
import '../../domain/entities/photo_spec.dart';

/// DATA · `case.json` → domain varlıkları. Hikâye metni kodda değil JSON'da durur.
/// Fotoğraf yolları JSON'da Dosya klasörüne göre yazılır; burada pakete göre tamamlanır.
abstract final class CaseFileMapper {
  static CaseFile fromJson(Map<String, dynamic> j) {
    final id = j['id'] as String;
    String asset(String rel) => 'assets/case_files/$id/$rel';
    final timeline = j['timeline'] as Map?;
    return CaseFile(
      id: id,
      number: j['number'] as int,
      title: j['title'] as String,
      summary: j['summary'] as String? ?? '',
      tags: [for (final t in (j['tags'] as List? ?? const [])) t as String],
      intro: _lines(j['intro']),
      people: [
        for (final p in (j['people'] as List? ?? const []))
          _person(p as Map<String, dynamic>)
      ],
      reels: [
        for (final r in (j['reels'] as List))
          _reel(r as Map<String, dynamic>, asset)
      ],
      reelCount: j['reelCount'] as int? ?? 0,
      timelineTitle: timeline?['title'] as String? ?? '',
      timelineDate: timeline?['date'] as String? ?? '',
      timeline: [
        for (final e in (timeline?['events'] as List? ?? const []))
          (
            tag: (e as Map)['tag'] as String,
            title: e['title'] as String,
            body: e['body'] as String? ?? ''
          ),
      ],
      finale: j['finale'] == null
          ? null
          : _finale(j['finale'] as Map<String, dynamic>),
    );
  }

  static List<IntroLine> _lines(Object? raw) => [
        for (final l in (raw as List? ?? const []))
          line(Map<String, dynamic>.from(l as Map))
      ];

  static IntroLine line(Map<String, dynamic> j) => IntroLine(
        text: j['text'] as String,
        speaker: j['speaker'] as String?,
        style: _style(j['style'] as String?),
        sfx: j['sfx'] as String?,
        image: j['image'] as String?,
      );

  static LineStyle _style(String? name) => switch (name) {
        'paper' => LineStyle.paper,
        'letter' => LineStyle.letter,
        'photo' => LineStyle.photo,
        _ => LineStyle.plain,
      };

  static Person _person(Map<String, dynamic> j) => Person(
        id: j['id'] as String,
        name: j['name'] as String,
        initial:
            j['initial'] as String? ?? (j['name'] as String).substring(0, 1),
        role: j['role'] as String? ?? '',
        known: j['known'] as bool? ?? false,
      );

  static Reel _reel(Map<String, dynamic> j, String Function(String) asset) =>
      Reel(
        number: j['number'] as int,
        title: j['title'] as String,
        intro: j['intro'] as String? ?? '',
        question: j['question'] == null
            ? null
            : _question(j['question'] as Map<String, dynamic>),
        frames: [
          for (final f in (j['frames'] as List))
            _frame(f as Map<String, dynamic>, asset)
        ],
      );

  static ReelQuestion _question(Map<String, dynamic> j) {
    final options = j['options'] as List;
    return ReelQuestion(
      text: j['text'] as String,
      options: [
        for (final o in options)
          (id: (o as Map)['id'] as String, text: o['text'] as String)
      ],
      truth: j['truth'] as String,
      truthNote: j['truthNote'] as String?,
      replies: {
        for (final o in options)
          if ((o as Map)['reply'] != null)
            o['id'] as String:
                line(Map<String, dynamic>.from(o['reply'] as Map)),
      },
      outro: _lines(j['outro']),
    );
  }

  static Finale _finale(Map<String, dynamic> j) => Finale(
        eyebrow: j['eyebrow'] as String? ?? '',
        intro: _lines(j['intro']),
        question: j['question'] as String,
        hint: j['hint'] as String? ?? '',
        options: [
          for (final o in (j['options'] as List))
            FinaleOption(
              id: (o as Map)['id'] as String,
              text: o['text'] as String,
              detail: o['detail'] as String? ?? '',
              ending: _lines(o['ending']),
            ),
        ],
        epilogue: _lines(j['epilogue']),
      );

  static Frame _frame(Map<String, dynamic> j, String Function(String) asset) =>
      Frame(
        number: j['number'] as int,
        search: j['search'] as bool? ?? false,
        reaction: j['reaction'] == null
            ? null
            : line(Map<String, dynamic>.from(j['reaction'] as Map)),
        scene: j['scene'] == null
            ? null
            : _scene(j['scene'] as Map<String, dynamic>),
        puzzle: Puzzle.fromRows(
            [for (final r in (j['puzzle'] as List)) r as String]),
        photo: PhotoSpec(
          asset: asset(j['photo'] as String),
          title: j['title'] as String,
          date: j['date'] as String? ?? '',
          hotspots: [
            for (final h in (j['hotspots'] as List? ?? const []))
              _hotspot(h as Map<String, dynamic>)
          ],
        ),
      );

  static Scene _scene(Map<String, dynamic> j) => Scene(
        eyebrow: j['eyebrow'] as String? ?? '',
        title: j['title'] as String? ?? '',
        lines: _lines(j['lines']),
      );

  static Hotspot _hotspot(Map<String, dynamic> h) => Hotspot(
        id: h['id'] as String,
        center: Offset((h['x'] as num).toDouble(), (h['y'] as num).toDouble()),
        radius: (h['r'] as num).toDouble(),
        title: h['title'] as String,
        body: h['body'] as String,
        tag: h['tag'] as String?,
        kind: HotspotKind.values.asNameMap()[h['kind']] ?? HotspotKind.clue,
        personId: h['person'] as String?,
      );
}
