import '../entities/case_progress.dart';

/// İlerlemenin saklandığı yer. Domain, Hive'ı ya da başka bir depoyu bilmez.
abstract interface class ProgressRepository {
  /// Verilen Dosyaların kayıtlı ilerlemesi (kaydı olmayanlar dönmez).
  Map<String, CaseProgress> loadAll(Iterable<String> caseIds);

  Future<void> save(CaseProgress progress);

  /// Ayarlar > İlerlemeyi sıfırla.
  Future<void> clearAll();
}
