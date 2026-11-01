import '../../domain/repositories/interstitial_ads.dart';

/// Reklamsız ortam (testler, reklam ağı kurulmadan önce).
class NoInterstitialAds implements InterstitialAds {
  const NoInterstitialAds();

  @override
  void preload() {}

  @override
  Future<bool> show() async => false;
}
