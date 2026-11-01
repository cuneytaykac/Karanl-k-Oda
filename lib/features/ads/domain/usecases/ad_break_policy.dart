/// Geçiş reklamının ne zaman gösterileceği. Oyuncuyu reklama boğmamak için kurallar:
/// - Yalnızca rulo aralarında (bulmaca, hikâye ya da inceleme sırasında asla).
/// - İlk rulo reklamsız: ilk geçiş reklamı en erken 1. rulo bitince gelir.
/// - İki geçiş reklamı arasında en az [minGap].
/// - Oyuncu az önce ipucu için reklam izlediyse ([rewardedCooldown] içinde) atlanır.
class AdBreakPolicy {
  const AdBreakPolicy({
    this.minGap = const Duration(minutes: 10),
    this.rewardedCooldown = const Duration(minutes: 3),
    this.firstReelWithBreak = 2,
  });

  final Duration minGap;
  final Duration rewardedCooldown;

  /// Bu rulonun başlangıcından önce ilk kez reklam gösterilebilir.
  final int firstReelWithBreak;

  bool shouldShow({
    required int nextReel,
    required DateTime now,
    DateTime? lastInterstitial,
    DateTime? lastRewarded,
  }) {
    if (nextReel < firstReelWithBreak) return false;
    if (lastInterstitial != null && now.difference(lastInterstitial) < minGap) {
      return false;
    }
    if (lastRewarded != null && now.difference(lastRewarded) < rewardedCooldown) {
      return false;
    }
    return true;
  }
}
