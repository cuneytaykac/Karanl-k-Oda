import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:karanlik_oda/core/locale/content_language.dart';
import 'package:karanlik_oda/features/content/data/datasources/case_json_datasource.dart';
import 'package:karanlik_oda/features/content/data/models/case_file_mapper.dart';

/// Çeviriler asıl metinle aynı oyunu anlatmalı: yalnızca okunan metin değişir.
void main() {
  // Metin olmayan alanlar: çeviride birebir aynı kalmalı.
  const fixed = {
    'id', 'number', 'photo', 'style', 'sfx', 'speaker', 'person', 'kind',
    'image', 'truth', 'puzzle', 'x', 'y', 'r', 'search', 'reelCount', 'known',
  };

  /// İki JSON ağacını karşılaştırır; farkları yol yol listeler.
  void compare(Object? a, Object? b, String path, List<String> diffs) {
    if (a is Map && b is Map) {
      if (a.keys.toSet().difference(b.keys.toSet()).isNotEmpty ||
          b.keys.toSet().difference(a.keys.toSet()).isNotEmpty) {
        diffs.add('$path: alanlar farklı');
        return;
      }
      for (final k in a.keys) {
        if (fixed.contains(k)) {
          if (jsonEncode(a[k]) != jsonEncode(b[k])) diffs.add('$path.$k');
        } else {
          compare(a[k], b[k], '$path.$k', diffs);
        }
      }
    } else if (a is List && b is List) {
      if (a.length != b.length) {
        diffs.add('$path: uzunluk ${a.length} ≠ ${b.length}');
        return;
      }
      for (var i = 0; i < a.length; i++) {
        compare(a[i], b[i], '$path[$i]', diffs);
      }
    } else if (a.runtimeType != b.runtimeType) {
      diffs.add('$path: tür farklı');
    }
  }

  Map<String, dynamic> read(String path) =>
      jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;

  for (final id in CaseJsonDataSource.bundledCaseIds) {
    group('$id · İngilizce', () {
      final dir = 'assets/case_files/$id';
      final tr = read('$dir/case.json');
      final en = read('$dir/case.en.json');

      test('yapı asıl dosyayla birebir aynı', () {
        final diffs = <String>[];
        compare(tr, en, id, diffs);
        expect(diffs, isEmpty, reason: diffs.take(10).join('\n'));
      });

      test('Türkçe kalmış metin yok (özel isimler hariç)', () {
        const names = [
          'Aydın', 'Rıza', 'Ayşe', 'AYŞE', 'İzmir', 'DEMİR', 'Kuyumculuk',
          'Karanlık Oda', 'KARACA',
        ];
        final leftovers = <String>[];
        void walk(Object? node, String key) {
          if (node is Map) {
            node.forEach((k, v) {
              if (!fixed.contains(k)) walk(v, k as String);
            });
          } else if (node is List) {
            for (final v in node) {
              walk(v, key);
            }
          } else if (node is String) {
            var s = node;
            for (final n in names) {
              s = s.replaceAll(n, '');
            }
            if (RegExp('[çğışöüÇĞİŞÖÜâ]').hasMatch(s)) leftovers.add(node);
          }
        }

        walk(en, '');
        expect(leftovers, isEmpty, reason: leftovers.take(5).join('\n'));
      });

      test('İngilizce dosya oyuna yüklenebiliyor', () {
        final file = CaseFileMapper.fromJson(en);
        expect(file.title, isNot(CaseFileMapper.fromJson(tr).title));
        expect(file.reels.length, 7);
      });
    });
  }

  group('İçerik dili', () {
    test('Türkçe telefon Türkçe, diğerleri İngilizce', () {
      expect(contentLanguage(const [Locale('tr', 'TR')]), 'tr');
      expect(contentLanguage(const [Locale('en', 'GB')]), 'en');
      expect(contentLanguage(const [Locale('de', 'DE')]), 'en');
      expect(contentLanguage(const [Locale('de'), Locale('tr')]), 'tr',
          reason: 'desteklenen ilk tercih');
    });
  });
}
