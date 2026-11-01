/// Geçiş reklamı (rulo aralarında). Domain hangi reklam ağının kullanıldığını bilmez.
abstract interface class InterstitialAds {
  /// Sonraki reklamı önceden yükler.
  void preload();

  /// Reklam hazırsa gösterir ve kapanınca true döner; hazır değilse hemen false.
  Future<bool> show();
}
