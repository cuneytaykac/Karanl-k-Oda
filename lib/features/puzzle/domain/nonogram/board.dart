import 'cell_state.dart';
import 'clues.dart';
import 'puzzle.dart';

/// Oyuncunun ızgaradaki o anki hâli. Değişmez (immutable):
/// her değişiklik yeni bir [Board] döndürür, böylece geri alma kolaydır.
class Board {
  Board._(this.puzzle, this.cells);

  /// Boş tahta.
  factory Board.empty(Puzzle puzzle) => Board._(puzzle,
      List.unmodifiable(List.filled(puzzle.cellCount, CellState.empty)));

  /// Kayıttan geri yükleme. Uzunluk tutmazsa boş tahta döner.
  factory Board.fromCells(Puzzle puzzle, List<CellState> cells) {
    if (cells.length != puzzle.cellCount) return Board.empty(puzzle);
    return Board._(puzzle, List.unmodifiable(cells));
  }

  final Puzzle puzzle;
  final List<CellState> cells;

  int get width => puzzle.width;
  int get height => puzzle.height;

  CellState cellAt(int row, int col) => cells[puzzle.indexOf(row, col)];

  /// Birden fazla hücreyi tek seferde değiştirir.
  Board withCells(Map<int, CellState> changes) {
    if (changes.isEmpty) return this;
    final next = List<CellState>.of(cells);
    changes.forEach((i, s) => next[i] = s);
    return Board._(puzzle, List.unmodifiable(next));
  }

  Board withCell(int row, int col, CellState state) =>
      withCells({puzzle.indexOf(row, col): state});

  List<bool> _filledRow(int r) => [
        for (var c = 0; c < width; c++) cells[r * width + c] == CellState.filled
      ];

  List<bool> _filledCol(int c) => [
        for (var r = 0; r < height; r++)
          cells[r * width + c] == CellState.filled
      ];

  /// Satırdaki dolu bloklar ipucuyla birebir aynı mı? (Arayüzde sayıyı soldurmak için.)
  bool isRowSatisfied(int row) =>
      sameRuns(runsOf(_filledRow(row)), puzzle.rowClues[row]);

  bool isColSatisfied(int col) =>
      sameRuns(runsOf(_filledCol(col)), puzzle.colClues[col]);

  /// Satır çözümle birebir aynı mı? (İpucu ve hata kontrolü için.)
  bool isRowCorrect(int row) {
    for (var c = 0; c < width; c++) {
      if ((cells[row * width + c] == CellState.filled) !=
          puzzle.isFilled(row, c)) {
        return false;
      }
    }
    return true;
  }

  /// Bulmaca çözüldü mü? Tüm satırlar ve sütunlar ipuçlarını sağlıyorsa evet.
  ///
  /// Çözümle birebir aynı olmak şart değil: ipuçlarına uyan başka bir dizilim
  /// bulunursa da oyuncu haklı sayılır. (İçeriği tek çözümlü yapmak [isUniquelySolvable]
  /// ile kontrol edilir.)
  bool get isSolved {
    for (var r = 0; r < height; r++) {
      if (!isRowSatisfied(r)) return false;
    }
    for (var c = 0; c < width; c++) {
      if (!isColSatisfied(c)) return false;
    }
    return true;
  }

  /// Çözümde boş olduğu hâlde doldurulmuş hücreler.
  List<int> get wrongFills => [
        for (var i = 0; i < cells.length; i++)
          if (cells[i] == CellState.filled && !puzzle.isFilledAt(i)) i,
      ];

  /// Çözümle çelişen bütün hücreler: boş olması gerekirken doldurulanlar ve
  /// dolu olması gerekirken × konanlar. İpucu bunları kırmızıyla gösterir.
  List<int> get mistakes => [
        for (var i = 0; i < cells.length; i++)
          if ((cells[i] == CellState.filled && !puzzle.isFilledAt(i)) ||
              (cells[i] == CellState.crossed && puzzle.isFilledAt(i)))
            i,
      ];

  /// Oyuncu bitirdiğini sanıyor ama yanlış: çözümdeki kadar (ya da daha çok)
  /// kare doldurulmuş, yine de ipuçları tutmuyor. ("Negatif bulanık çıktı.")
  bool get looksFinishedButWrong =>
      filledCount >= puzzle.filledCount && !isSolved;

  int get filledCount => cells.where((s) => s == CellState.filled).length;

  /// Kayıt için.
  List<String> toJson() => [for (final s in cells) s.name];

  static Board fromJson(Puzzle puzzle, List<dynamic> json) {
    final states = <CellState>[];
    for (final v in json) {
      final s = CellState.values.asNameMap()[v];
      if (s == null) return Board.empty(puzzle);
      states.add(s);
    }
    return Board.fromCells(puzzle, states);
  }
}
