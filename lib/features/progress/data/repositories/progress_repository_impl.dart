import '../../../../core/storage/storage.dart';
import '../../domain/entities/case_progress.dart';
import '../../domain/repositories/progress_repository.dart';
import '../models/case_progress_mapper.dart';

/// İlerlemeyi cihazdaki [Storage]'a (Hive) yazar.
class ProgressRepositoryImpl implements ProgressRepository {
  const ProgressRepositoryImpl(this._storage);
  final Storage _storage;

  @override
  Map<String, CaseProgress> loadAll(Iterable<String> caseIds) => {
        for (final id in caseIds)
          if (_storage.readCaseProgress(id) case final raw?)
            id: CaseProgressMapper.fromJson(id, raw),
      };

  @override
  Future<void> save(CaseProgress progress) => _storage.writeCaseProgress(
      progress.caseId, CaseProgressMapper.toJson(progress));

  @override
  Future<void> clearAll() => _storage.clearAllProgress();
}

/// Kayıt yeri olmadığında (testler): ilerleme yalnızca bellekte tutulur.
class InMemoryProgressRepository implements ProgressRepository {
  final _items = <String, CaseProgress>{};

  @override
  Map<String, CaseProgress> loadAll(Iterable<String> caseIds) => {
        for (final id in caseIds)
          if (_items[id] case final p?) id: p,
      };

  @override
  Future<void> save(CaseProgress progress) async =>
      _items[progress.caseId] = progress;

  @override
  Future<void> clearAll() async => _items.clear();
}
