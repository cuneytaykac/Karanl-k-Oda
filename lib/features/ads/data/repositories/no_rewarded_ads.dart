import '../../domain/entities/rewarded_ad_result.dart';
import '../../domain/repositories/rewarded_ads.dart';

/// Reklamsız ortam (testler, reklam ağı kurulmadan önce): reklam hiç yoktur.
class NoRewardedAds implements RewardedAds {
  const NoRewardedAds();

  @override
  void preload() {}

  @override
  Future<RewardedAdResult> show() async => RewardedAdResult.unavailable;
}
