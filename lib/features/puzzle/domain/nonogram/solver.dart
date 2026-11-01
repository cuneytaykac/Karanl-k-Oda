import 'puzzle.dart';

/// Çözücünün her hücre için vardığı sonuç.
enum Known { unknown, filled, empty }

/// Mantıksal (tahminsiz) çözücü sonucu.
class SolveResult {
  const SolveResult(this.grid, this.width, this.contradiction);

  final List<Known> grid;
  final int width;

  /// İpuçları birbiriyle çelişiyor (bulmaca hatalı).
  final bool contradiction;

  bool get complete => !contradiction && !grid.contains(Known.unknown);

  int get unknownCount => grid.where((k) => k == Known.unknown).length;
}

/// Satır satır mantık yürüterek çözer: her satır/sütun için ipucuna uyan
/// TÜM yerleşimleri bulur, hepsinde aynı olan hücreleri kesinleştirir;
/// değişiklik kalmayana kadar tekrarlar.
///
/// Sonuç [SolveResult.complete] ise bulmaca hem tek çözümlüdür hem de
/// oyuncu tahmin etmeden çözebilir. İçerik hazırlarken her kare bununla
/// kontrol edilmeli (bkz. test/engine/content_puzzles_test.dart).
SolveResult solveByLogic(List<List<int>> rowClues, List<List<int>> colClues) {
  final h = rowClues.length, w = colClues.length;
  final grid = List<Known>.filled(w * h, Known.unknown);

  bool changed = true;
  while (changed) {
    changed = false;
    for (var r = 0; r < h; r++) {
      final line = [for (var c = 0; c < w; c++) grid[r * w + c]];
      final next = _solveLine(rowClues[r], line);
      if (next == null) return SolveResult(grid, w, true);
      for (var c = 0; c < w; c++) {
        if (next[c] != line[c]) {
          grid[r * w + c] = next[c];
          changed = true;
        }
      }
    }
    for (var c = 0; c < w; c++) {
      final line = [for (var r = 0; r < h; r++) grid[r * w + c]];
      final next = _solveLine(colClues[c], line);
      if (next == null) return SolveResult(grid, w, true);
      for (var r = 0; r < h; r++) {
        if (next[r] != line[r]) {
          grid[r * w + c] = next[r];
          changed = true;
        }
      }
    }
  }
  return SolveResult(grid, w, false);
}

/// Bu bulmaca tahminsiz ve tek çözümle bitirilebiliyor mu?
bool isUniquelySolvable(Puzzle p) {
  final res = solveByLogic(p.rowClues, p.colClues);
  if (!res.complete) return false;
  for (var i = 0; i < p.cellCount; i++) {
    if ((res.grid[i] == Known.filled) != p.isFilledAt(i)) return false;
  }
  return true;
}

/// Tek satır: bilinenlerle uyumlu tüm yerleşimlerin kesişimi.
/// Hiç uyumlu yerleşim yoksa `null` (çelişki).
List<Known>? _solveLine(List<int> clue, List<Known> line) {
  final n = line.length;
  final canFill = List<bool>.filled(n, false);
  final canEmpty = List<bool>.filled(n, false);

  // memo[blok][konum] = bu noktadan sonrası yerleştirilebilir mi
  final memo = <int, bool>{};

  bool fits(int b, int pos) {
    final key = b * (n + 2) + pos;
    final cached = memo[key];
    if (cached != null) return cached;

    bool ok = false;
    if (b == clue.length) {
      // Kalan her şey boş olmalı.
      ok = true;
      for (var i = pos; i < n; i++) {
        if (line[i] == Known.filled) {
          ok = false;
          break;
        }
      }
      if (ok) {
        for (var i = pos; i < n; i++) {
          canEmpty[i] = true;
        }
      }
      memo[key] = ok;
      return ok;
    }

    final len = clue[b];
    for (var start = pos; start + len <= n; start++) {
      // start'tan önceki (pos..start-1) hücreler boş olmalı.
      if (start > pos && line[start - 1] == Known.filled) break;
      var blockOk = true;
      for (var i = start; i < start + len; i++) {
        if (line[i] == Known.empty) {
          blockOk = false;
          break;
        }
      }
      if (!blockOk) continue;
      final end = start + len;
      if (end < n && line[end] == Known.filled) continue;
      final nextPos = end < n ? end + 1 : end;
      if (fits(b + 1, nextPos)) {
        ok = true;
        for (var i = pos; i < start; i++) {
          canEmpty[i] = true;
        }
        for (var i = start; i < end; i++) {
          canFill[i] = true;
        }
        if (end < n) canEmpty[end] = true;
      }
    }
    memo[key] = ok;
    return ok;
  }

  if (!fits(0, 0)) return null;

  return [
    for (var i = 0; i < n; i++)
      canFill[i] && canEmpty[i]
          ? Known.unknown
          : canFill[i]
              ? Known.filled
              : Known.empty,
  ];
}
