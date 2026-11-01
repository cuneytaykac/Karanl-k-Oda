import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../domain/entities/case_progress.dart';

/// Tüm Dosyaların ilerlemesi. Kuralları [CaseProgress] uygular, kaydı depo yapar;
/// bu sınıf yalnızca ikisini birleştirir ve ekranlara durumu yayınlar.
class ProgressController extends Notifier<Map<String, CaseProgress>> {
  @override
  Map<String, CaseProgress> build() => ref
      .read(progressRepositoryProvider)
      .loadAll(ref.read(contentRepositoryProvider).cases.keys);

  CaseProgress? of(String caseId) => state[caseId];

  CaseProgress _get(String caseId) =>
      state[caseId] ?? CaseProgress(caseId: caseId);

  void _apply(String caseId, CaseProgress? Function(CaseProgress) change) {
    final next = change(_get(caseId));
    if (next == null) return;
    state = {...state, caseId: next};
    ref.read(progressRepositoryProvider).save(next);
  }

  /// Dosya açılışı izlendi; ilerleme başlar (zaten başladıysa dokunmaz).
  void start(String caseId) {
    if (state.containsKey(caseId)) return;
    _apply(caseId, (p) => p.copyWith(reel: 1, frame: 1));
  }

  void markSolved(String caseId, int reel, int frame) =>
      _apply(caseId, (p) => p.solve(reel, frame));

  void advanceTo(String caseId, int reel, int frame) =>
      _apply(caseId, (p) => p.advanceTo(reel, frame));

  void addClue(String caseId, String clueId) =>
      _apply(caseId, (p) => p.addClue(clueId));

  void setTheory(String caseId, int reel, String optionId) =>
      _apply(caseId, (p) => p.chooseTheory(reel, optionId));

  void useHint(String caseId, int reel) =>
      _apply(caseId, (p) => p.useHint(reel));

  void earnAdHint(String caseId, int reel) =>
      _apply(caseId, (p) => p.earnAdHint(reel));

  void setEnding(String caseId, String optionId) =>
      _apply(caseId, (p) => p.close(optionId));

  /// Defter açıldı (alt menüdeki nokta söner). Başlamamış Dosyaya kayıt açmaz.
  void markNotebookSeen(String caseId) {
    if (!state.containsKey(caseId)) return;
    _apply(caseId, (p) => p.seeNotebook());
  }

  /// Ayarlar > İlerlemeyi sıfırla.
  Future<void> resetAll() async {
    state = const {};
    await ref.read(progressRepositoryProvider).clearAll();
  }
}

final progressProvider =
    NotifierProvider<ProgressController, Map<String, CaseProgress>>(
        ProgressController.new);

/// Banyo'da "devam et" gösterilecek Dosya: en son oynanan.
final activeProgressProvider = Provider<CaseProgress?>((ref) {
  final all = ref.watch(progressProvider).values.toList();
  if (all.isEmpty) return null;
  all.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  return all.first;
});
