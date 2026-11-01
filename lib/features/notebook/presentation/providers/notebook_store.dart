import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../../content/domain/entities/case_file.dart';
import '../../../content/domain/entities/photo_spec.dart';
import '../../../progress/presentation/providers/progress_providers.dart';

/// Deftere düşen bir ipucu.
class NotebookClue {
  const NotebookClue({
    required this.id,
    required this.caseId,
    required this.reel,
    required this.frame,
    required this.title,
    required this.body,
    this.tag,
    this.kind = HotspotKind.clue,
    this.personId,
  });

  final String id;
  final String caseId;
  final int reel;
  final int frame;
  final String title;
  final String body;
  final String? tag;

  /// Defterin hangi sekmesine düşer: ipucu, zaman ya da kişi.
  final HotspotKind kind;
  final String? personId;

  /// "R2 · K3" biçiminde kaynak.
  String get source => 'R$reel · K$frame';
}

/// Defterdeki ipuçları.
///
/// Cihaza yalnızca ipucu kimlikleri yazılır (ilerleme kaydında); başlık, açıklama
/// ve etiket açılışta Dosya içeriğinden yeniden kurulur. Böylece metin düzeltmeleri
/// eski kayıtlara da yansır.
class NotebookController extends Notifier<List<NotebookClue>> {
  @override
  List<NotebookClue> build() {
    final library = ref.read(contentRepositoryProvider);
    final progress = ref.read(progressProvider);
    final result = <NotebookClue>[];
    for (final p in progress.values) {
      final file = library.cases[p.caseId];
      if (file == null) continue;
      for (final id in p.clues) {
        final clue = _find(p.caseId, file.reels, id);
        if (clue != null) result.add(clue);
      }
    }
    return result;
  }

  static NotebookClue? _find(String caseId, List<Reel> reels, String id) {
    for (final reel in reels) {
      for (final frame in reel.frames) {
        for (final h in frame.photo.hotspots) {
          if (h.id == id) {
            return NotebookClue(
              id: h.id,
              caseId: caseId,
              reel: reel.number,
              frame: frame.number,
              title: h.title,
              body: h.body,
              tag: h.tag,
              kind: h.kind,
              personId: h.personId,
            );
          }
        }
      }
    }
    return null;
  }

  bool contains(String id) => state.any((c) => c.id == id);

  /// Aynı ipucu iki kez eklenmez. Eklendiyse true.
  bool add(NotebookClue clue) {
    if (contains(clue.id)) return false;
    state = [...state, clue];
    ref.read(progressProvider.notifier).addClue(clue.caseId, clue.id);
    return true;
  }
}

final notebookProvider =
    NotifierProvider<NotebookController, List<NotebookClue>>(
        NotebookController.new);
