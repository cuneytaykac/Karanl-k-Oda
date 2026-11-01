import 'package:flutter_test/flutter_test.dart';
import 'package:karanlik_oda/features/puzzle/domain/nonogram/board.dart';
import 'package:karanlik_oda/features/puzzle/domain/nonogram/cell_state.dart';
import 'package:karanlik_oda/features/puzzle/domain/nonogram/puzzle.dart';

import 'fixtures.dart';

/// Çözümü tahtaya birebir yazar.
Board solved(Puzzle p) {
  var b = Board.empty(p);
  for (var r = 0; r < p.height; r++) {
    for (var c = 0; c < p.width; c++) {
      if (p.isFilled(r, c)) b = b.withCell(r, c, CellState.filled);
    }
  }
  return b;
}

void main() {
  final p = Puzzle.fromRows(fish);

  test('boş tahta çözülmüş sayılmaz', () {
    final b = Board.empty(p);
    expect(b.isSolved, isFalse);
    expect(b.filledCount, 0);
    // İpucu "0" olan satır boşken zaten sağlanmış görünür (sayı söner).
    expect(b.isRowSatisfied(0), isTrue);
    expect(b.isRowSatisfied(1), isFalse);
  });

  test('çözüm yazılınca çözülür', () {
    final b = solved(p);
    expect(b.isSolved, isTrue);
    expect(b.wrongFills, isEmpty);
    for (var r = 0; r < p.height; r++) {
      expect(b.isRowCorrect(r), isTrue, reason: 'satır $r');
    }
  });

  test('× işaretleri çözümü bozmaz', () {
    var b = solved(p);
    b = b.withCell(0, 0, CellState.crossed).withCell(9, 9, CellState.crossed);
    expect(b.isSolved, isTrue);
  });

  test('fazladan bir kare çözümü bozar ve hatalı sayılır', () {
    final b = solved(p).withCell(0, 0, CellState.filled);
    expect(b.isSolved, isFalse);
    expect(b.wrongFills, [0]);
    expect(b.isRowSatisfied(0), isFalse);
  });

  test('eksik bir kare çözümü bozar', () {
    final b = solved(p).withCell(4, 4, CellState.empty);
    expect(b.isSolved, isFalse);
    expect(b.isRowSatisfied(4), isFalse);
  });

  test('ipuçlarını sağlayan farklı bir dizilim de çözüm sayılır', () {
    final a = Puzzle.fromRows(ambiguous2x2);
    final other = Board.empty(a)
        .withCell(0, 1, CellState.filled)
        .withCell(1, 0, CellState.filled);
    expect(other.isSolved, isTrue);
    expect(other.wrongFills, isNotEmpty);
  });

  test('tahta değişmez: withCell eskiyi bozmaz', () {
    final a = Board.empty(p);
    final b = a.withCell(1, 2, CellState.filled);
    expect(a.cellAt(1, 2), CellState.empty);
    expect(b.cellAt(1, 2), CellState.filled);
    expect(() => b.cells[0] = CellState.filled, throwsUnsupportedError);
  });

  test('kayıt: JSON gidiş-dönüş', () {
    final b = solved(p).withCell(0, 0, CellState.crossed);
    final back = Board.fromJson(p, b.toJson());
    expect(back.cells, b.cells);
  });

  test('bozuk kayıt boş tahtaya döner', () {
    expect(Board.fromJson(p, ['filled']).filledCount, 0);
    expect(Board.fromJson(p, List.filled(100, 'bilinmeyen')).filledCount, 0);
  });
}
