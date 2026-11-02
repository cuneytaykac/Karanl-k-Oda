import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../domain/entities/rewarded_ad_result.dart';
import '../../domain/repositories/rewarded_ads.dart';
import '../datasources/ad_unit_ids.dart';

/// Google AdMob ödüllü reklamı. Bir reklam hep önceden yüklü tutulur.
class AdmobRewardedAds implements RewardedAds {
  /// Oyuncu düğmeye bastığında reklam henüz yüklenmediyse en fazla bu kadar beklenir.
  static const _waitForLoad = Duration(seconds: 4);

  RewardedAd? _ad;
  Completer<RewardedAd?>? _loading;

  @override
  void preload() => _load();

  Future<RewardedAd?> _load() {
    if (_ad != null) return Future.value(_ad);
    final pending = _loading;
    if (pending != null) return pending.future;
    final loading = _loading = Completer<RewardedAd?>();
    RewardedAd.load(
      adUnitId: AdUnitIds.rewarded,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('[Reklam] Ödüllü reklam yüklendi');
          _ad = ad;
          _loading = null;
          loading.complete(ad);
        },
        onAdFailedToLoad: (error) {
          debugPrint('[Reklam] Ödüllü reklam yüklenemedi: '
              '${error.code} ${error.message}');
          _loading = null;
          loading.complete(null);
        },
      ),
    );
    return loading.future;
  }

  @override
  Future<RewardedAdResult> show() async {
    final ad = await _load().timeout(_waitForLoad, onTimeout: () => null);
    if (ad == null) {
      debugPrint('[Reklam] Ödüllü reklam hazır değil → reklam yok');
      return RewardedAdResult.unavailable;
    }
    _ad = null;

    final result = Completer<RewardedAdResult>();
    var earned = false;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        preload();
        result.complete(
            earned ? RewardedAdResult.earned : RewardedAdResult.dismissed);
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
        preload();
        result.complete(RewardedAdResult.unavailable);
      },
    );
    await ad.show(onUserEarnedReward: (_, __) => earned = true);
    return result.future;
  }
}
