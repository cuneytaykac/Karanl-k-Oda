import 'dart:convert';

import 'package:flutter/material.dart';

/// DATA · Paketteki Dosyaları okur, oyuncunun diline göre.
///
/// Her Dosya `assets/case_files/<id>/case.json` (Türkçe, asıl metin) olarak durur.
/// Başka bir dilin çevirisi varsa `case.<dil>.json` yanında durur (örn. `case.en.json`);
/// çeviri yoksa Türkçesi açılır.
class CaseJsonDataSource {
  const CaseJsonDataSource(this._bundle, {this.language = 'tr'});
  final AssetBundle _bundle;

  /// İçerik dili: 'tr' ya da 'en'.
  final String language;

  /// Pakette bulunan Dosyalar. Yeni Dosya eklenince buraya kimliği yazılır.
  static const bundledCaseIds = ['wrong_man'];

  /// Asıl metnin dili.
  static const sourceLanguage = 'tr';

  Future<List<Map<String, dynamic>>> loadAll(
          {List<String> ids = bundledCaseIds}) async =>
      [for (final id in ids) await _loadCase(id)];

  Future<Map<String, dynamic>> _loadCase(String id) async {
    final dir = 'assets/case_files/$id';
    if (language != sourceLanguage) {
      try {
        return _decode(await _bundle.loadString('$dir/case.$language.json'));
      } on FlutterError {
        // Bu dilde çeviri yok: asıl metne düş.
      }
    }
    return _decode(await _bundle.loadString('$dir/case.json'));
  }

  /// Yakında gelecek Dosyalar (Dosyalar sekmesindeki kilitli kartlar).
  Future<List<Map<String, dynamic>>> loadUpcoming() async {
    final list =
        jsonDecode(await _bundle.loadString('assets/case_files/upcoming.json'))
            as List;
    return [
      for (final e in list.cast<Map<String, dynamic>>())
        {
          'number': e['number'],
          'title': _pick(e['title']),
          'blurb': _pick(e['blurb']),
        },
    ];
  }

  String _pick(Object? texts) {
    final map = (texts as Map).cast<String, String>();
    return map[language] ?? map[sourceLanguage] ?? '';
  }

  static Map<String, dynamic> _decode(String raw) =>
      jsonDecode(raw) as Map<String, dynamic>;
}
