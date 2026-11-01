/// Çözülen bir karenin özeti: negatif ekranına taşınır.
class FrameResult {
  const FrameResult({required this.solveTime, required this.hintsUsed});

  final Duration? solveTime;
  final int hintsUsed;

  /// "2:41" biçimi. Süre bilinmiyorsa "–".
  String get timeLabel {
    final t = solveTime;
    if (t == null) return '–';
    final m = t.inMinutes;
    final s = t.inSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}
