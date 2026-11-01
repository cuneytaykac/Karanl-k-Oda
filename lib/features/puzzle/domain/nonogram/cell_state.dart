/// Bir ızgara hücresinin oyuncu tarafından verilen durumu.
enum CellState {
  /// Henüz dokunulmadı.
  empty,

  /// Oyuncu "dolu" dedi (siyah kare).
  filled,

  /// Oyuncu "kesin boş" dedi (× işareti).
  crossed,
}

/// Oyuncunun kullandığı araç: doldurma ya da × koyma.
enum Tool {
  fill,
  cross;

  CellState get state =>
      this == Tool.fill ? CellState.filled : CellState.crossed;
}
