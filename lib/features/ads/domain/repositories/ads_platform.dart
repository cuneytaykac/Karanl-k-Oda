/// Reklam ağının kendisi: başlatma ve oyuncu onayı (Avrupa'da GDPR).
/// Domain ve ekranlar hangi ağın kullanıldığını bilmez.
abstract interface class AdsPlatform {
  /// Gerekiyorsa onay formunu gösterir (yalnızca yasal zorunluluk olan bölgelerde),
  /// sonra reklam ağını başlatır. Reklam istenebilirse true döner.
  Future<bool> start();

  /// Oyuncunun onayını sonradan değiştirebileceği "Gizlilik seçenekleri" gerekli mi?
  Future<bool> privacyOptionsRequired();

  /// Gizlilik seçenekleri formunu gösterir.
  Future<void> showPrivacyOptions();
}
