import 'dart:convert';

import 'package:flutter/services.dart';

/// DATA · Paketteki `assets/case_files/<id>/case.json` dosyalarını okur.
class CaseJsonDataSource {
  const CaseJsonDataSource(this._bundle);
  final AssetBundle _bundle;

  /// Pakette bulunan Dosyalar. Yeni Dosya eklenince buraya kimliği yazılır.
  static const bundledCaseIds = ['wrong_man'];

  Future<List<Map<String, dynamic>>> loadAll(
          {List<String> ids = bundledCaseIds}) async =>
      [
        for (final id in ids)
          jsonDecode(
                  await _bundle.loadString('assets/case_files/$id/case.json'))
              as Map<String, dynamic>,
      ];
}
