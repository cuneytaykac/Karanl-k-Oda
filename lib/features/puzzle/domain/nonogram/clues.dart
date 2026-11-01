/// Bir satırdaki ardışık dolu blokların uzunlukları.
///
/// `[t, t, f, t]` → `[2, 1]`. Hiç dolu yoksa boş liste döner;
/// arayüz bunu "0" olarak gösterir.
List<int> runsOf(Iterable<bool> line) {
  final runs = <int>[];
  var current = 0;
  for (final filled in line) {
    if (filled) {
      current++;
    } else if (current > 0) {
      runs.add(current);
      current = 0;
    }
  }
  if (current > 0) runs.add(current);
  return runs;
}

/// İki ipucu listesi aynı mı?
bool sameRuns(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
