import '../../domain/entities/case_progress.dart';

/// [CaseProgress] ↔ cihazdaki JSON kaydı.
abstract final class CaseProgressMapper {
  static Map<String, dynamic> toJson(CaseProgress p) => {
        'reel': p.reel,
        'frame': p.frame,
        'solved': p.solved.toList(),
        'clues': p.clues,
        'theories': {for (final e in p.theories.entries) '${e.key}': e.value},
        'notebookSeen': p.notebookSeen,
        'hintsUsed': {for (final e in p.hintsUsed.entries) '${e.key}': e.value},
        'adHints': {for (final e in p.adHints.entries) '${e.key}': e.value},
        if (p.ending != null) 'ending': p.ending,
        'updatedAt': p.updatedAt,
      };

  /// Kayıt bozuksa ya da eski sürümden kaldıysa güvenli varsayılanlara düşer.
  static CaseProgress fromJson(String caseId, Map<String, dynamic> j) {
    int readInt(String k, int fallback) => j[k] is int ? j[k] as int : fallback;
    List<String> readList(String k) => [
          for (final v in (j[k] is List ? j[k] as List : const []))
            if (v is String) v,
        ];
    Map<dynamic, dynamic> readMap(String k) =>
        j[k] is Map ? j[k] as Map : const {};
    Map<int, int> readCounts(String k) => {
          for (final e in readMap(k).entries)
            if (int.tryParse('${e.key}') != null && e.value is int)
              int.parse('${e.key}'): e.value as int,
        };

    return CaseProgress(
      caseId: caseId,
      reel: readInt('reel', 1).clamp(1, 99),
      frame: readInt('frame', 1).clamp(1, 99),
      solved: readList('solved').toSet(),
      clues: readList('clues'),
      theories: {
        for (final e in readMap('theories').entries)
          if (int.tryParse('${e.key}') != null && e.value is String)
            int.parse('${e.key}'): e.value as String,
      },
      notebookSeen: readInt('notebookSeen', 0),
      hintsUsed: readCounts('hintsUsed'),
      adHints: readCounts('adHints'),
      ending: j['ending'] is String ? j['ending'] as String : null,
      updatedAt: readInt('updatedAt', 0),
    );
  }
}
