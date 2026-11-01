import 'package:flutter_test/flutter_test.dart';
import 'package:karanlik_oda/features/puzzle/domain/nonogram/puzzle.dart';
import 'package:karanlik_oda/features/puzzle/domain/nonogram/solver.dart';

import 'fixtures.dart';

void main() {
  test('balık tahminsiz ve tek çözümle çözülür', () {
    expect(isUniquelySolvable(Puzzle.fromRows(fish)), isTrue);
  });

  test('yeni öğretici saat tahminsiz çözülür', () {
    expect(isUniquelySolvable(Puzzle.fromRows(tutorialClock)), isTrue);
  });

  test('eski öğretici taslağı yakalanır (tek çözümlü değil)', () {
    final p = Puzzle.fromRows(oldTutorialDraft);
    final res = solveByLogic(p.rowClues, p.colClues);
    expect(res.complete, isFalse);
    expect(res.unknownCount, greaterThan(0));
    expect(isUniquelySolvable(p), isFalse);
  });

  test('iki çözümlü bulmaca reddedilir', () {
    expect(isUniquelySolvable(Puzzle.fromRows(ambiguous2x2)), isFalse);
  });

  test('çelişkili ipuçları yakalanır', () {
    // Satır 3 dolu diyor ama sütunlar toplam 1 kare izin veriyor.
    final res = solveByLogic(
      [
        [3],
      ],
      [
        [1],
        <int>[],
        [1],
      ],
    );
    expect(res.contradiction, isTrue);
  });

  test('tam dolu ve tek kareli uç durumlar', () {
    expect(isUniquelySolvable(Puzzle.fromRows(['###', '###'])), isTrue);
    expect(isUniquelySolvable(Puzzle.fromRows(['...', '.#.', '...'])), isTrue);
  });

  test('15×15 bulmaca hızlı çözülür', () {
    final rows = [
      for (var r = 0; r < 15; r++)
        [
          for (var c = 0; c < 15; c++)
            (r == c || r + c == 14 || r == 7 || c == 7) ? '#' : '.'
        ].join(),
    ];
    final sw = Stopwatch()..start();
    final res = solveByLogic(
        Puzzle.fromRows(rows).rowClues, Puzzle.fromRows(rows).colClues);
    sw.stop();
    expect(res.contradiction, isFalse);
    expect(sw.elapsedMilliseconds, lessThan(500));
  });
}
