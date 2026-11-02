import 'board.dart';
import 'cell_state.dart';
import 'puzzle.dart';

/// Bir bulmacanın oynanışı: tahta, araç, sürükleme, geri alma, ipucu.
///
/// Saf Dart; Flutter bilmez. Arayüz yalnızca [startStroke] / [extendStroke] /
/// [endStroke] çağırır ve [board]'u çizer.
class PuzzleSession {
  PuzzleSession(this.puzzle,
      {Board? board, this.hintsLeft = 3, this.maxUndo = 200})
      : _board = board ?? Board.empty(puzzle);

  final Puzzle puzzle;
  final int maxUndo;
  int hintsLeft;

  Board _board;
  Board get board => _board;

  Tool tool = Tool.fill;

  final List<Board> _undo = [];
  bool get canUndo => _undo.isNotEmpty;

  // ---- Sürükleme (stroke) ----
  // Kurallar:
  // 1. İlk dokunulan hücre ne yapılacağını belirler: hücre zaten aracın
  //    durumundaysa "silme", değilse "boyama".
  // 2. Boyama yalnızca boş hücreleri değiştirir (×'leri ezmez); silme yalnızca
  //    aracın durumundaki hücreleri boşaltır.
  // 3. Sürükleme ilk hareket ettiği eksende (satır ya da sütun) kilitlenir;
  //    parmak çapraz kaysa da çizgi düz kalır.
  // 4. Bir sürükleme tek geri alma adımıdır.

  int? _startRow, _startCol;
  bool? _horizontal;
  late bool _erasing;
  Board? _beforeStroke;

  bool get isStroking => _startRow != null;

  void startStroke(int row, int col) {
    if (!_inside(row, col)) return;
    _beforeStroke = _board;
    _startRow = row;
    _startCol = col;
    _horizontal = null;
    _erasing = _board.cellAt(row, col) == tool.state;
    _applyLine(row, col);
  }

  void extendStroke(int row, int col) {
    if (!isStroking) return;
    row = row.clamp(0, puzzle.height - 1);
    col = col.clamp(0, puzzle.width - 1);
    if (_horizontal == null && (row != _startRow || col != _startCol)) {
      _horizontal = (col - _startCol!).abs() >= (row - _startRow!).abs();
    }
    _applyLine(row, col);
  }

  void endStroke() {
    if (!isStroking) return;
    final before = _beforeStroke!;
    if (!identical(before, _board) && !_sameCells(before, _board)) {
      _pushUndo(before);
    }
    _startRow = _startCol = _horizontal = _beforeStroke = null;
  }

  /// Tek dokunuş = başla + bitir.
  void tap(int row, int col) {
    startStroke(row, col);
    endStroke();
  }

  void _applyLine(int row, int col) {
    final sr = _startRow!, sc = _startCol!;
    final List<(int, int)> line;
    if (_horizontal == null) {
      line = [(sr, sc)];
    } else if (_horizontal!) {
      final a = sc < col ? sc : col, b = sc < col ? col : sc;
      line = [for (var c = a; c <= b; c++) (sr, c)];
    } else {
      final a = sr < row ? sr : row, b = sr < row ? row : sr;
      line = [for (var r = a; r <= b; r++) (r, sc)];
    }

    // Her uzatmada çizgiyi sürükleme başındaki tahtadan yeniden hesapla;
    // böylece parmak geri çekilince hücreler eski hâline döner.
    final base = _beforeStroke!;
    final changes = <int, CellState>{};
    for (final (r, c) in line) {
      final current = base.cellAt(r, c);
      if (_erasing) {
        if (current == tool.state) {
          changes[puzzle.indexOf(r, c)] = CellState.empty;
        }
      } else {
        if (current == CellState.empty) {
          changes[puzzle.indexOf(r, c)] = tool.state;
        }
      }
    }
    _board = base.withCells(changes);
  }

  // ---- Diğer eylemler ----

  void undo() {
    if (isStroking) endStroke();
    if (_undo.isEmpty) return;
    _board = _undo.removeLast();
  }

  void clear() {
    if (_board.filledCount == 0 && !_board.cells.contains(CellState.crossed)) {
      return;
    }
    _pushUndo(_board);
    _board = Board.empty(puzzle);
  }

  /// İlk hatalı satırı çözümle değiştirir (dolular doldurulur, boşlara × konur).
  /// İpucu hakkı yoksa ya da tüm satırlar doğruysa `null` döner, hak düşmez.
  /// İpucu: tahtadaki yanlış kareleri gösterir (tahtayı değiştirmeden).
  /// Bir ipucu hakkı harcar. Yanlış yoksa ya da hak bittiyse null.
  List<int>? revealMistakes() {
    if (hintsLeft <= 0) return null;
    final mistakes = _board.mistakes;
    if (mistakes.isEmpty) return null;
    hintsLeft--;
    return mistakes;
  }

  int? useHint() {
    if (hintsLeft <= 0) return null;
    for (var r = 0; r < puzzle.height; r++) {
      if (_board.isRowCorrect(r) && _rowHasNoStrayMarks(r)) continue;
      final changes = <int, CellState>{
        for (var c = 0; c < puzzle.width; c++)
          puzzle.indexOf(r, c):
              puzzle.isFilled(r, c) ? CellState.filled : CellState.crossed,
      };
      _pushUndo(_board);
      _board = _board.withCells(changes);
      hintsLeft--;
      return r;
    }
    return null;
  }

  bool get isSolved => _board.isSolved;

  // ---- Yardımcılar ----

  /// Satır doğru ama boş kalması gereken hücrelerde hâlâ işaretsiz yer var mı?
  /// (İpucu satırı tamamen bitirsin diye: × eksikse yine ipucu verilir.)
  bool _rowHasNoStrayMarks(int r) {
    for (var c = 0; c < puzzle.width; c++) {
      if (!puzzle.isFilled(r, c) && _board.cellAt(r, c) == CellState.empty) {
        return false;
      }
    }
    return true;
  }

  bool _inside(int r, int c) =>
      r >= 0 && c >= 0 && r < puzzle.height && c < puzzle.width;

  void _pushUndo(Board b) {
    _undo.add(b);
    if (_undo.length > maxUndo) _undo.removeAt(0);
  }

  static bool _sameCells(Board a, Board b) {
    for (var i = 0; i < a.cells.length; i++) {
      if (a.cells[i] != b.cells[i]) return false;
    }
    return true;
  }
}
