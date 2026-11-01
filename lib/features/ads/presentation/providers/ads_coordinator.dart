import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/dev_flags.dart';
import '../../../../core/di/providers.dart';
import '../../domain/entities/rewarded_ad_result.dart';
import '../../domain/repositories/interstitial_ads.dart';
import '../../domain/repositories/rewarded_ads.dart';
import '../../domain/usecases/ad_break_policy.dart';

/// Oyundaki tüm reklamların tek giriş kapısı. Ne zaman reklam gösterileceğini
/// [AdBreakPolicy] söyler; hangi reklamın gösterildiğini burası hatırlar.
class AdsCoordinator {
  AdsCoordinator(
    this._rewarded,
    this._interstitial, {
    this.policy = const AdBreakPolicy(),
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final RewardedAds _rewarded;
  final InterstitialAds _interstitial;
  final AdBreakPolicy policy;
  final DateTime Function() _now;

  DateTime? _lastInterstitial;
  DateTime? _lastRewarded;

  /// İpucu için ödüllü reklam.
  Future<RewardedAdResult> showRewarded() async {
    final result = await _rewarded.show();
    if (result != RewardedAdResult.unavailable) _lastRewarded = _now();
    return result;
  }

  /// Rulo arası: kurallar izin veriyorsa geçiş reklamı gösterir; kapanınca döner.
  Future<void> reelBreak({required int nextReel}) async {
    final allowed = policy.shouldShow(
      nextReel: nextReel,
      now: _now(),
      lastInterstitial: _lastInterstitial,
      lastRewarded: _lastRewarded,
    );
    if (!allowed) return;
    if (await _interstitial.show()) _lastInterstitial = _now();
  }
}

final adsCoordinatorProvider = Provider<AdsCoordinator>((ref) => AdsCoordinator(
      ref.watch(rewardedAdsProvider),
      ref.watch(interstitialAdsProvider),
      // GELİŞTİRME: reklamları denerken her rulo arasında (dev_flags.dart).
      policy: kDevFrequentAdBreaks
          ? const AdBreakPolicy(
              minGap: Duration.zero, rewardedCooldown: Duration.zero)
          : const AdBreakPolicy(),
    ));
