import 'clues.dart';

/// Bir nonogram bulmacasının değişmeyen tanımı: çözüm ve ipuçları.
///
/// Hücreler satır satır (row-major) tutulur: indeks = satır * genişlik + sütun.
class Puzzle {
  Puzzle._(this.width, this.height, this._solution)
      : rowClues = List.unmodifiable([
          for (var r = 0; r < height; r++)
            List<int>.unmodifiable(runsOf(_row(_solution, width, r))),
        ]),
        colClues = List.unmodifiable([
          for (var c = 0; c < width; c++)
            List<int>.unmodifiable(runsOf(_col(_solution, width, height, c))),
        ]);

  /// Metinden bulmaca: `#` dolu, `.` boş. Boşluklar yok sayılır.
  ///
  /// ```dart
  /// Puzzle.fromRows(['.##.', '#..#']);
  /// ```
  factory Puzzle.fromRows(List<String> rows) {
    final cleaned = [for (final r in rows) r.replaceAll(' ', '')];
    if (cleaned.isEmpty || cleaned.first.isEmpty) {
      throw const FormatException('Bulmaca boş olamaz.');
    }
    final width = cleaned.first.length;
    final cells = <bool>[];
    for (var r = 0; r < cleaned.length; r++) {
      final row = cleaned[r];
      if (row.length != width) {
        throw FormatException(
            'Satır ${r + 1} uzunluğu $width değil (${row.length}).');
      }
      for (final ch in row.split('')) {
        if (ch == '#') {
          cells.add(true);
        } else if (ch == '.') {
          cells.add(false);
        } else {
          throw FormatException(
              'Satır ${r + 1}: geçersiz karakter "$ch" (yalnızca # ve .).');
        }
      }
    }
    if (!cells.contains(true)) {
      throw const FormatException('Bulmacada en az bir dolu kare olmalı.');
    }
    return Puzzle._(width, cleaned.length, List.unmodifiable(cells));
  }

  final int width;
  final int height;
  final List<bool> _solution;

  /// Her satırın ipucu sayıları (soldan sağa).
  final List<List<int>> rowClues;

  /// Her sütunun ipucu sayıları (yukarıdan aşağıya).
  final List<List<int>> colClues;

  int get cellCount => width * height;

  int indexOf(int row, int col) {
    RangeError.checkValidIndex(row, null, 'row', height);
    RangeError.checkValidIndex(col, null, 'col', width);
    return row * width + col;
  }

  bool isFilled(int row, int col) => _solution[indexOf(row, col)];

  bool isFilledAt(int index) => _solution[index];

  /// Çözümdeki dolu kare sayısı.
  int get filledCount => _solution.where((filled) => filled).length;

  List<bool> solutionRow(int row) => _row(_solution, width, row);

  List<bool> solutionCol(int col) => _col(_solution, width, height, col);

  /// Geri metne çevirir (test ve hata ayıklama için).
  List<String> toRows() => [
        for (var r = 0; r < height; r++)
          solutionRow(r).map((f) => f ? '#' : '.').join(),
      ];

  static List<bool> _row(List<bool> cells, int width, int r) =>
      cells.sublist(r * width, r * width + width);

  static List<bool> _col(List<bool> cells, int width, int height, int c) => [
        for (var r = 0; r < height; r++) cells[r * width + c],
      ];
}
