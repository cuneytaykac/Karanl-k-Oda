import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/ads/data/repositories/no_ads_platform.dart';
import '../../features/ads/data/repositories/no_interstitial_ads.dart';
import '../../features/ads/data/repositories/no_rewarded_ads.dart';
import '../../features/ads/domain/repositories/ads_platform.dart';
import '../../features/ads/domain/repositories/interstitial_ads.dart';
import '../../features/ads/domain/repositories/rewarded_ads.dart';
import '../../features/content/data/repositories/content_repository_impl.dart';
import '../../features/content/domain/repositories/content_repository.dart';
import '../../features/progress/data/repositories/progress_repository_impl.dart';
import '../../features/progress/domain/repositories/progress_repository.dart';
import '../storage/storage.dart';

export '../../features/ads/domain/repositories/ads_platform.dart';
export '../../features/ads/domain/repositories/interstitial_ads.dart';
export '../../features/ads/domain/repositories/rewarded_ads.dart';
export '../../features/content/domain/repositories/content_repository.dart';
export '../../features/progress/domain/repositories/progress_repository.dart';

/// BAĞIMLILIKLAR · Domain arayüzlerini data uygulamalarına bağlar.
/// Presentation katmanı yalnızca bu sağlayıcıları ve domain arayüzlerini tanır.

/// Hikâye içeriği. main() gerçek yüklenmiş içerikle değiştirir; testlerde boş.
final contentRepositoryProvider =
    Provider<ContentRepository>((ref) => ContentRepositoryImpl.empty);

/// Oyuncunun ilerlemesi. Cihaz kaydı yoksa (testler) bellekte tutulur.
final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  try {
    return ProgressRepositoryImpl(ref.read(storageProvider));
  } catch (_) {
    // Riverpod 3 sağlayıcı hatasını ProviderException içine sarar; türüne bakmıyoruz.
    return InMemoryProgressRepository();
  }
});

/// Ödüllü reklam. main() gerçek reklam ağını verir; testlerde reklam yoktur.
final rewardedAdsProvider =
    Provider<RewardedAds>((ref) => const NoRewardedAds());

/// Rulo arası geçiş reklamı. main() gerçek reklam ağını verir; testlerde reklam yoktur.
final interstitialAdsProvider =
    Provider<InterstitialAds>((ref) => const NoInterstitialAds());

/// Reklam ağı ve oyuncu onayı. main() AdMob'u verir; testlerde reklam yoktur.
final adsPlatformProvider =
    Provider<AdsPlatform>((ref) => const NoAdsPlatform());
