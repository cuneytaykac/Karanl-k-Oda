import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

/// Cihazdaki kayıt katmanı.
///
/// Oyunun geri kalanı Hive'ı doğrudan bilmez; yalnızca bu sınıfı kullanır.
/// İleride Drift'e geçmek gerekirse sadece bu dosya değişir.
class Storage {
  Storage._(this._settingsBox, this._progressBox);

  final Box<dynamic> _settingsBox;
  final Box<dynamic> _progressBox;

  static const _settingsBoxName = 'settings';
  static const _progressBoxName = 'progress';

  static Future<Storage> init() async {
    await Hive.initFlutter('karanlik_oda');
    final settings = await Hive.openBox<dynamic>(_settingsBoxName);
    final progress = await Hive.openBox<dynamic>(_progressBoxName);
    return Storage._(settings, progress);
  }

  // ---- Ayarlar ----
  Map<String, dynamic> readSettings() => Map<String, dynamic>.from(_settingsBox
      .get('values', defaultValue: const <String, dynamic>{}) as Map);

  Future<void> writeSettings(Map<String, dynamic> values) =>
      _settingsBox.put('values', values);

  // ---- Tek seferlik işaretler (örn. ilk açılış görüldü). Ayarlardan ayrı tutulur. ----
  bool readFlag(String name) =>
      _settingsBox.get('flag_$name', defaultValue: false) == true;

  Future<void> writeFlag(String name, bool value) =>
      _settingsBox.put('flag_$name', value);

  // ---- İlerleme (her Dosya tek kayıt) ----
  Map<String, dynamic>? readCaseProgress(String caseId) {
    final raw = _progressBox.get(caseId);
    return raw == null ? null : Map<String, dynamic>.from(raw as Map);
  }

  Future<void> writeCaseProgress(String caseId, Map<String, dynamic> data) =>
      _progressBox.put(caseId, data);

  Future<void> deleteCaseProgress(String caseId) => _progressBox.delete(caseId);

  /// Ayarlar > Gizlilik > İlerlemeyi sıfırla. Ayarlar ve satın alım silinmez.
  Future<void> clearAllProgress() => _progressBox.clear();
}

/// main.dart içinde gerçek Storage ile değiştirilir.
final storageProvider = Provider<Storage>(
    (ref) => throw UnimplementedError('Storage main() içinde verilmeli'));
