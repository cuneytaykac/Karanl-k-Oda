import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:karanlik_oda/features/content/data/models/case_file_mapper.dart';
import 'package:karanlik_oda/features/content/data/repositories/content_repository_impl.dart';
import 'package:karanlik_oda/features/flow/domain/entities/flow_step.dart';
import 'package:karanlik_oda/features/flow/domain/usecases/next_step.dart';

void main() {
  final file = CaseFileMapper.fromJson(jsonDecode(
          File('assets/case_files/wrong_man/case.json').readAsStringSync())
      as Map<String, dynamic>);
  final content = ContentRepositoryImpl({file.id: file});
  const id = 'wrong_man';
  final last = file.reels.last;

  test('kare bitince sonraki kare; rulonun sonunda soru', () {
    expect(NextStep.afterFrame(content, id, 1, 3),
        isA<NextPuzzle>().having((s) => s.frame, 'frame', 4));
    final framesInReel = file.reel(1)!.frames.length;
    expect(NextStep.afterFrame(content, id, 1, framesInReel),
        isA<AskQuestion>().having((s) => s.reel, 'reel', 1));
  });

  test('sahnesi olan kareden sonra önce sahne', () {
    final withScene = [
      for (final r in file.reels)
        for (final f in r.frames)
          if (f.scene != null) (r.number, f.number)
    ].first;
    expect(NextStep.afterInspect(content, id, withScene.$1, withScene.$2),
        isA<ShowScene>());
  });

  test('sorudan sonra sonraki rulo; son rulodan sonra son karar', () {
    expect(NextStep.afterQuestion(content, id, 1),
        isA<StartReel>().having((s) => s.reel, 'reel', 2));
    expect(NextStep.afterQuestion(content, id, last.number), isA<ShowFinale>());
  });

  test('bilinmeyen Dosya: Banyo', () {
    expect(NextStep.afterQuestion(content, 'yok', 1), isA<BackToDeveloping>());
  });
}
