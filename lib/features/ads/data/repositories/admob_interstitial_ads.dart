import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../domain/repositories/interstitial_ads.dart';
import '../datasources/ad_unit_ids.dart';

/// Google AdMob geçiş reklamı. Hazır değilse beklenmez: oyuncu reklamsız devam eder.
class AdmobInterstitialAds implements InterstitialAds {
  InterstitialAd? _ad;
  bool _loading = false;

  @override
  void preload() {
    if (_ad != null || _loading) return;
    _loading = true;
    InterstitialAd.load(
      adUnitId: AdUnitIds.interstitial,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _ad = ad;
          _loading = false;
        },
        onAdFailedToLoad: (_) => _loading = false,
      ),
    );
  }

  @override
  Future<bool> show() async {
    final ad = _ad;
    if (ad == null) {
      preload();
      return false;
    }
    _ad = null;
    final closed = Completer<bool>();
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        preload();
        closed.complete(true);
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
        preload();
        closed.complete(false);
      },
    );
    await ad.show();
    return closed.future;
  }
}
