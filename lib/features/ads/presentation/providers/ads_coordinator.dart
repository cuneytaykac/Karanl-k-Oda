import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/dev_flags.dart';
import '../../../../core/di/providers.dart';
import '../../domain/entities/rewarded_ad_result.dart';
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

  /// Onay alınıp reklam ağı başlayana kadar hiçbir reklam istenmez.
  bool _enabled = false;

  /// Reklam ağı hazır ve oyuncu reklama izin veriyor: ilk reklamlar yüklensin.
  void enable() {
    debugPrint('[Reklam] Reklamlar açıldı, ilk reklamlar yükleniyor');
    _enabled = true;
    _rewarded.preload();
    _interstitial.preload();
  }

  /// İpucu için ödüllü reklam.
  /// Reklam yoksa (onay yok, ağ başlamadı, reklam yüklenmedi) sonuç "reklam yok"
  /// olur; ipucu verilmez.
  Future<RewardedAdResult> showRewarded() async {
    if (!_enabled) {
      debugPrint('[Reklam] Reklam sistemi başlamadı (onay yok ya da '
          'AdMob başlatılmadı) → reklam yok');
      return RewardedAdResult.unavailable;
    }
    final result = await _rewarded.show();
    if (result != RewardedAdResult.unavailable) _lastRewarded = _now();
    return result;
  }

  /// Rulo arası: kurallar izin veriyorsa geçiş reklamı gösterir; kapanınca döner.
  Future<void> reelBreak({required int nextReel}) async {
    if (!_enabled) return;
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

/// Uygulama açılınca bir kez: onay (gerekiyorsa) → reklam ağı → ilk reklamlar.
/// Açılış sahnesi bittikten sonra başlatılır; form sahnenin üstüne çıkmasın.
final adsStartupProvider = FutureProvider<void>((ref) async {
  final allowed = await ref.read(adsPlatformProvider).start();
  if (allowed) ref.read(adsCoordinatorProvider).enable();
  // Onay değişmiş olabilir: Ayarlar'daki satır yeniden sorsun.
  ref.invalidate(privacyOptionsRequiredProvider);
});

/// Ayarlar'da "Gizlilik seçenekleri" satırı gösterilsin mi (Avrupa'da zorunlu).
final privacyOptionsRequiredProvider = FutureProvider<bool>(
    (ref) => ref.read(adsPlatformProvider).privacyOptionsRequired());
