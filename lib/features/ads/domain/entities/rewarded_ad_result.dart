/// Ödüllü reklamın sonucu.
enum RewardedAdResult {
  /// Oyuncu reklamı sonuna kadar izledi: ödül verilir.
  earned,

  /// Oyuncu reklamı yarıda kapattı: ödül yok.
  dismissed,

  /// Gösterilecek reklam yok (internet yok, reklam dolmadı, reklamlar kapalı).
  unavailable,
}
