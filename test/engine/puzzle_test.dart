import 'package:flutter_test/flutter_test.dart';
import 'package:karanlik_oda/features/puzzle/domain/nonogram/clues.dart';
import 'package:karanlik_oda/features/puzzle/domain/nonogram/puzzle.dart';

import 'fixtures.dart';

void main() {
  group('runsOf', () {
    test('temel durumlar', () {
      expect(runsOf([]), isEmpty);
      expect(runsOf([false, false]), isEmpty);
      expect(runsOf([true]), [1]);
      expect(runsOf([true, true, false, true]), [2, 1]);
      expect(runsOf([false, true, true, true, false]), [3]);
      expect(runsOf([true, false, true, false, true]), [1, 1, 1]);
    });

    test('sameRuns', () {
      expect(sameRuns([1, 2], [1, 2]), isTrue);
      expect(sameRuns([1, 2], [2, 1]), isFalse);
      expect(sameRuns([], []), isTrue);
      expect(sameRuns([1], []), isFalse);
    });
  });

  group('Puzzle.fromRows', () {
    test('balık: boyut ve ipuçları', () {
      final p = Puzzle.fromRows(fish);
      expect(p.width, 10);
      expect(p.height, 10);
      expect(p.rowClues[0], isEmpty);
      expect(p.rowClues[1], [4, 1]);
      expect(p.rowClues[2], [6, 2]);
      expect(p.rowClues[3], [2, 7]);
      expect(p.rowClues[4], [10]);
      expect(p.rowClues[8], [2]);
      expect(p.colClues[0], [3]);
      expect(p.colClues[2], [2, 4]);
      expect(p.colClues[9], [7]);
    });

    test('metne geri çevirince aynı', () {
      expect(Puzzle.fromRows(fish).toRows(), fish);
    });

    test('dikdörtgen bulmaca (15×10 gibi) desteklenir', () {
      final p = Puzzle.fromRows(['#..', '.#.']);
      expect(p.width, 3);
      expect(p.height, 2);
      expect(p.colClues, [
        [1],
        [1],
        <int>[],
      ]);
    });

    test('boşluklar yok sayılır', () {
      expect(Puzzle.fromRows(['# . #']).rowClues.first, [1, 1]);
    });

    test('hatalı girişler açık mesajla reddedilir', () {
      expect(() => Puzzle.fromRows([]), throwsFormatException);
      expect(() => Puzzle.fromRows(['..', '..']), throwsFormatException);
      expect(() => Puzzle.fromRows(['#.', '#']), throwsFormatException);
      expect(() => Puzzle.fromRows(['#x']), throwsFormatException);
    });

    test('ipucu listeleri dışarıdan değiştirilemez', () {
      final p = Puzzle.fromRows(fish);
      expect(() => p.rowClues[1].add(9), throwsUnsupportedError);
      expect(() => p.rowClues.add([1]), throwsUnsupportedError);
    });

    test('ızgara dışı indeks hata verir', () {
      final p = Puzzle.fromRows(fish);
      expect(() => p.isFilled(10, 0), throwsRangeError);
      expect(() => p.isFilled(0, -1), throwsRangeError);
    });
  });
}
