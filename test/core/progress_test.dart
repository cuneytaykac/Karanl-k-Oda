import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:karanlik_oda/core/di/providers.dart';
import 'package:karanlik_oda/core/router/resume_location.dart';
import 'package:karanlik_oda/core/router/routes.dart';
import 'package:karanlik_oda/features/content/data/models/case_file_mapper.dart';
import 'package:karanlik_oda/features/content/data/repositories/content_repository_impl.dart';
import 'package:karanlik_oda/features/progress/data/models/case_progress_mapper.dart';
import 'package:karanlik_oda/features/progress/domain/entities/case_progress.dart';
import 'package:karanlik_oda/features/progress/domain/usecases/progress_rules.dart';
import 'package:karanlik_oda/features/progress/presentation/providers/progress_providers.dart';

void main() {
  final file = CaseFileMapper.fromJson(
    jsonDecode(File('assets/case_files/wrong_man/case.json').readAsStringSync())
        as Map<String, dynamic>,
  );
  final library = ContentRepositoryImpl({file.id: file});

  ProviderContainer container() {
    final c = ProviderContainer(
        overrides: [contentRepositoryProvider.overrideWithValue(library)]);
    addTearDown(c.dispose);
    return c;
  }

  test('JSON gidiş-dönüş bozulmuyor', () {
    const p = CaseProgress(
        caseId: 'wrong_man',
        reel: 1,
        frame: 6,
        solved: {'1.1', '1.2'},
        clues: ['a', 'b'],
        theories: {1: 'lake'});
    final q =
        CaseProgressMapper.fromJson('wrong_man', CaseProgressMapper.toJson(p));
    expect(q.reel, 1);
    expect(q.frame, 6);
    expect(q.solved, {'1.1', '1.2'});
    expect(q.clues, ['a', 'b']);
    expect(q.theories, {1: 'lake'});
  });

  test('bozuk kayıt çökmez, varsayılana döner', () {
    final q = CaseProgressMapper.fromJson('wrong_man', {
      'reel': 'x',
      'solved': 5,
      'clues': [1, 'ok'],
      'theories': {'a': 'b'}
    });
    expect(q.reel, 1);
    expect(q.frame, 1);
    expect(q.solved, isEmpty);
    expect(q.clues, ['ok']);
    expect(q.theories, isEmpty);
  });

  test('akış: başla → çöz → ilerle; kaldığın yer doğru', () {
    final c = container();
    final ctrl = c.read(progressProvider.notifier);
    expect(c.read(activeProgressProvider), isNull);

    ctrl.start('wrong_man');
    var p = c.read(activeProgressProvider)!;
    expect(resumeLocation(p, library), Routes.puzzle('wrong_man', 1, 1));

    ctrl.markSolved('wrong_man', 1, 1);
    p = c.read(activeProgressProvider)!;
    expect(resumeLocation(p, library), Routes.inspect('wrong_man', 1, 1),
        reason: 'çözülmüş kare incelemeden sürer');

    ctrl.advanceTo('wrong_man', 1, 2);
    p = c.read(activeProgressProvider)!;
    expect(resumeLocation(p, library), Routes.puzzle('wrong_man', 1, 2));

    // Eski kareyi yeniden oynamak ilerlemeyi geri almaz.
    ctrl.advanceTo('wrong_man', 1, 1);
    expect(c.read(activeProgressProvider)!.frame, 2);
  });

  test('rulo bitti: önce teori sorusu, sonra (sonraki rulo yoksa) bekleme', () {
    final c = container();
    final ctrl = c.read(progressProvider.notifier);
    ctrl.advanceTo('wrong_man', 1, 11);
    var p = c.read(activeProgressProvider)!;
    expect(needsTheory(p, library), isTrue);
    expect(isWaitingForNextReel(p, library), isFalse);
    expect(resumeLocation(p, library), Routes.question('wrong_man', 1));

    ctrl.setTheory('wrong_man', 1, 'lake');
    p = c.read(activeProgressProvider)!;
    expect(needsTheory(p, library), isFalse);
    expect(isWaitingForNextReel(p, library), isFalse, reason: 'Rulo 2 var');
    expect(resumeLocation(p, library), Routes.reelIntro('wrong_man', 2));
  });

  test('son rulo bitti: soru → son karar → kapanış', () {
    final c = container();
    final ctrl = c.read(progressProvider.notifier);
    final last = file.reels.last;
    ctrl.advanceTo('wrong_man', last.number, last.frames.length + 1);
    var p = c.read(activeProgressProvider)!;
    expect(
        resumeLocation(p, library), Routes.question('wrong_man', last.number));

    ctrl.setTheory('wrong_man', last.number, last.question!.truth);
    p = c.read(activeProgressProvider)!;
    expect(needsFinale(p, library), isTrue);
    expect(resumeLocation(p, library), Routes.finale('wrong_man'));

    ctrl.setEnding('wrong_man', file.finale!.options.first.id);
    p = c.read(activeProgressProvider)!;
    expect(p.isClosed, isTrue);
    expect(resumeLocation(p, library), Routes.ending('wrong_man'));
    expect(
        CaseProgressMapper.fromJson('wrong_man', CaseProgressMapper.toJson(p))
            .ending,
        file.finale!.options.first.id);
  });

  test(
      'içerik: 7 rulo, her rulonun sorusu ve tepkileri var, final iki seçenekli',
      () {
    expect(file.reels, hasLength(7));
    for (final r in file.reels) {
      expect(r.frames, hasLength(10), reason: 'Rulo ${r.number}');
      final q = r.question!;
      expect(q.options.map((o) => o.id), contains(q.truth));
      for (final o in q.options) {
        expect(q.replies[o.id], isNotNull, reason: 'R${r.number} ${o.id}');
      }
      for (final f in r.frames) {
        expect(f.reaction, isNotNull, reason: 'R${r.number} K${f.number}');
        expect(f.photo.hotspots, isNotEmpty,
            reason: 'R${r.number} K${f.number}');
      }
    }
    expect(file.finale!.options, hasLength(2));
    for (final o in file.finale!.options) {
      expect(o.ending, isNotEmpty);
    }
  });

  test('rulo 1 sorusunun her seçeneğine bir tepki var', () {
    final q = file.reel(1)!.question!;
    for (final o in q.options) {
      expect(q.replies[o.id], isNotNull, reason: o.id);
    }
    expect(q.outro, isNotEmpty);
  });

  test('defter: yeni kayıt nokta yakar, açınca söner; zaman çizelgesi içerikte',
      () {
    final c = container();
    final ctrl = c.read(progressProvider.notifier);
    ctrl.start('wrong_man');
    expect(c.read(activeProgressProvider)!.hasUnseenNotes, isFalse);
    ctrl.addClue('wrong_man', 'wm.r1.clocks');
    expect(c.read(activeProgressProvider)!.hasUnseenNotes, isTrue);
    final before = c.read(activeProgressProvider)!.updatedAt;
    ctrl.markNotebookSeen('wrong_man');
    final p = c.read(activeProgressProvider)!;
    expect(p.hasUnseenNotes, isFalse);
    expect(p.updatedAt, before,
        reason: 'defteri açmak "en son oynanan"ı değiştirmez');
    expect(
        CaseProgressMapper.fromJson('wrong_man', CaseProgressMapper.toJson(p))
            .notebookSeen,
        1);
    expect(file.timeline.map((e) => e.tag), contains('12:30'));
  });
}
