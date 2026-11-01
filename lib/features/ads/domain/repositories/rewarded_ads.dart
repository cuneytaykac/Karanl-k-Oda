import '../entities/rewarded_ad_result.dart';

/// Ödüllü reklam. Domain ve ekranlar hangi reklam ağının kullanıldığını bilmez.
abstract interface class RewardedAds {
  /// Sonraki reklamı önceden yükler; gösterim anında beklemek gerekmesin.
  void preload();

  /// Reklamı gösterir ve oyuncu kapatınca sonucu döndürür.
  Future<RewardedAdResult> show();
}
