import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:karanlik_oda/features/content/data/datasources/case_json_datasource.dart';
import 'package:karanlik_oda/features/content/data/models/case_file_mapper.dart';
import 'package:karanlik_oda/features/puzzle/domain/nonogram/solver.dart';

/// Pakete giren her Dosya'nın içerik denetimi. Yeni rulo yazınca bu test bekçidir.
void main() {
  for (final id in CaseJsonDataSource.bundledCaseIds) {
    final file = CaseFileMapper.fromJson(
      jsonDecode(File('assets/case_files/$id/case.json').readAsStringSync())
          as Map<String, dynamic>,
    );

    group('Dosya "$id"', () {
      test('kişiler tekil, ayrıntıdaki kişi tanımlı', () {
        final ids = file.people.map((p) => p.id).toSet();
        expect(ids.length, file.people.length);
        for (final r in file.reels) {
          for (final f in r.frames) {
            for (final h in f.photo.hotspots) {
              if (h.personId != null) {
                expect(ids, contains(h.personId), reason: h.id);
              }
            }
          }
        }
      });

      test('ayrıntı kimlikleri bütün Dosya boyunca tekil', () {
        final all = [
          for (final r in file.reels)
            for (final f in r.frames)
              for (final h in f.photo.hotspots) h.id
        ];
        expect(all.toSet().length, all.length);
      });

      for (final r in file.reels) {
        test(
            'Rulo ${r.number}: kareler 1..n sırayla, soru ve doğru cevap tutarlı',
            () {
          expect([for (final f in r.frames) f.number],
              [for (var i = 1; i <= r.frames.length; i++) i]);
          final q = r.question;
          if (q != null) expect(q.options.map((o) => o.id), contains(q.truth));
        });

        for (final f in r.frames) {
          test(
              'R${r.number}K${f.number} "${f.photo.title}": bulmaca tahminsiz ve tek çözümlü',
              () {
            expect(isUniquelySolvable(f.puzzle), isTrue);
          });

          test(
              'R${r.number}K${f.number}: fotoğraf dosyası var, en az bir ayrıntı var',
              () {
            expect(File(f.photo.asset).existsSync(), isTrue,
                reason: f.photo.asset);
            expect(f.photo.hotspots, isNotEmpty);
          });
        }
      }
    });
  }
}
