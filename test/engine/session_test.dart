import 'package:flutter_test/flutter_test.dart';
import 'package:karanlik_oda/features/puzzle/domain/nonogram/cell_state.dart';
import 'package:karanlik_oda/features/puzzle/domain/nonogram/puzzle.dart';
import 'package:karanlik_oda/features/puzzle/domain/nonogram/session.dart';

import 'fixtures.dart';

void main() {
  late PuzzleSession s;
  setUp(() => s = PuzzleSession(Puzzle.fromRows(fish)));

  CellState at(int r, int c) => s.board.cellAt(r, c);

  group('dokunma', () {
    test('boş kareye dokununca dolar, tekrar dokununca boşalır', () {
      s.tap(1, 2);
      expect(at(1, 2), CellState.filled);
      s.tap(1, 2);
      expect(at(1, 2), CellState.empty);
    });

    test('× aracı', () {
      s.tool = Tool.cross;
      s.tap(0, 0);
      expect(at(0, 0), CellState.crossed);
      s.tap(0, 0);
      expect(at(0, 0), CellState.empty);
    });

    test('doldurma aracı ×\'i ezmez', () {
      s.tool = Tool.cross;
      s.tap(0, 0);
      s.tool = Tool.fill;
      s.tap(0, 0);
      expect(at(0, 0), CellState.crossed);
    });

    test('ızgara dışına dokunmak hiçbir şey yapmaz', () {
      s.tap(-1, 3);
      s.tap(3, 10);
      expect(s.board.filledCount, 0);
      expect(s.canUndo, isFalse);
    });
  });

  group('sürükleme', () {
    test('yatay sürükleme satırı doldurur', () {
      s.startStroke(4, 0);
      s.extendStroke(4, 9);
      s.endStroke();
      for (var c = 0; c < 10; c++) {
        expect(at(4, c), CellState.filled);
      }
    });

    test('çapraz kayma ilk eksende kilitlenir', () {
      s.startStroke(4, 2);
      s.extendStroke(4, 5); // önce yatay
      s.extendStroke(6, 7); // parmak aşağı kaydı
      s.endStroke();
      for (var c = 2; c <= 7; c++) {
        expect(at(4, c), CellState.filled, reason: 'sütun $c');
      }
      expect(at(6, 7), CellState.empty);
      expect(at(5, 7), CellState.empty);
    });

    test('dikey sürükleme', () {
      s.startStroke(1, 0);
      s.extendStroke(5, 0);
      s.endStroke();
      for (var r = 1; r <= 5; r++) {
        expect(at(r, 0), CellState.filled);
      }
    });

    test('geri çekilince fazlası geri alınır', () {
      s.startStroke(4, 0);
      s.extendStroke(4, 8);
      s.extendStroke(4, 3);
      s.endStroke();
      expect(at(4, 3), CellState.filled);
      expect(at(4, 4), CellState.empty);
    });

    test('dolu kareden başlayan sürükleme siler, × olanlara dokunmaz', () {
      s.startStroke(4, 0);
      s.extendStroke(4, 9);
      s.endStroke();
      s.tool = Tool.cross;
      s.tap(4, 5); // dolu kareye × konmaz
      expect(at(4, 5), CellState.filled);

      s.tool = Tool.fill;
      s.startStroke(4, 0);
      s.extendStroke(4, 9);
      s.endStroke();
      expect(s.board.filledCount, 0);
    });

    test('dışarı taşan sürükleme kenarda durur', () {
      s.startStroke(2, 7);
      s.extendStroke(2, 40);
      s.endStroke();
      expect(at(2, 9), CellState.filled);
    });

    test('bir sürükleme tek geri alma adımıdır', () {
      s.startStroke(4, 0);
      s.extendStroke(4, 5);
      s.extendStroke(4, 9);
      s.endStroke();
      s.undo();
      expect(s.board.filledCount, 0);
      expect(s.canUndo, isFalse);
    });
  });

  group('geri alma ve temizleme', () {
    test('sırayla geri alır', () {
      s.tap(1, 2);
      s.tap(1, 3);
      s.undo();
      expect(at(1, 3), CellState.empty);
      expect(at(1, 2), CellState.filled);
    });

    test('değişiklik yapmayan dokunuş geri alma geçmişine girmez', () {
      s.tool = Tool.cross;
      s.tap(0, 0);
      s.tool = Tool.fill;
      s.tap(0, 0); // × üstünde doldurma: değişiklik yok
      s.undo();
      expect(at(0, 0), CellState.empty);
      expect(s.canUndo, isFalse);
    });

    test('temizle geri alınabilir', () {
      s.tap(1, 2);
      s.clear();
      expect(s.board.filledCount, 0);
      s.undo();
      expect(at(1, 2), CellState.filled);
    });

    test('geri alma geçmişi sınırlı', () {
      final small = PuzzleSession(Puzzle.fromRows(fish), maxUndo: 3);
      for (var c = 0; c < 6; c++) {
        small.tap(4, c);
      }
      var n = 0;
      while (small.canUndo) {
        small.undo();
        n++;
      }
      expect(n, 3);
    });
  });

  group('ipucu', () {
    test('ilk hatalı satırı çözer ve hak düşer', () {
      expect(s.hintsLeft, 3);
      final row = s.useHint();
      // Satır 0 (ipucu 0) boş ama × eksik → önce o tamamlanır.
      expect(row, 0);
      for (var c = 0; c < 10; c++) {
        expect(at(0, c), CellState.crossed);
      }
      expect(s.hintsLeft, 2);
      expect(s.useHint(), 1);
      expect(s.board.isRowCorrect(1), isTrue);
    });

    test('hak bitince ipucu verilmez', () {
      final none = PuzzleSession(Puzzle.fromRows(fish), hintsLeft: 0);
      expect(none.useHint(), isNull);
      expect(none.board.filledCount, 0);
    });

    test('ipucu geri alınabilir ama hak geri gelmez', () {
      s.useHint();
      s.undo();
      expect(s.board.cells.every((c) => c == CellState.empty), isTrue);
      expect(s.hintsLeft, 2);
    });

    test('hata varsa ipucu onları gösterir (tahtaya dokunmaz)', () {
      final p = Puzzle.fromRows(fish);
      final t = PuzzleSession(p, hintsLeft: 3);
      expect(t.revealMistakes(), isNull, reason: 'hata yok');
      expect(t.hintsLeft, 3);
      t.startStroke(0, 0); // satır 0 boş olmalı
      t.endStroke();
      final before = t.board;
      expect(t.revealMistakes(), [0]);
      expect(t.hintsLeft, 2);
      expect(identical(t.board, before), isTrue);
    });

    test('10 ipucuyla bulmaca tamamen çözülür', () {
      final many = PuzzleSession(Puzzle.fromRows(fish), hintsLeft: 99);
      while (many.useHint() != null) {}
      expect(many.isSolved, isTrue);
      expect(many.hintsLeft, 99 - 10);
    });
  });

  test('uçtan uca: oyuncu balığı satır satır çizip çözer', () {
    final p = Puzzle.fromRows(fish);
    for (var r = 0; r < p.height; r++) {
      var c = 0;
      while (c < p.width) {
        if (!p.isFilled(r, c)) {
          c++;
          continue;
        }
        final start = c;
        while (c < p.width && p.isFilled(r, c)) {
          c++;
        }
        s.startStroke(r, start);
        s.extendStroke(r, c - 1);
        s.endStroke();
      }
    }
    expect(s.isSolved, isTrue);
  });
}
