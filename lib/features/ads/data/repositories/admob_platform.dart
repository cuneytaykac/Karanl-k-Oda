import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../domain/repositories/ads_platform.dart';

/// Google AdMob + Google'ın onay aracı (UMP). Onay formunun içeriği (metinler,
/// diller, gizlilik politikası adresi) AdMob → Gizlilik ve mesajlaşma'da ayarlanır.
/// iPhone'daki takip izni (ATT) penceresi de aynı akışta gösterilir.
class AdmobPlatform implements AdsPlatform {
  AdmobPlatform({this.debugAsEurope = false});

  /// Geliştirirken Türkiye'den de Avrupa onay formunu görmek için.
  final bool debugAsEurope;

  @override
  Future<bool> start() async {
    await _updateConsentInfo();
    await _showFormIfRequired();
    final allowed = await ConsentInformation.instance.canRequestAds();
    final status = await ConsentInformation.instance.getConsentStatus();
    debugPrint('[Reklam] Onay durumu: $status · reklam istenebilir: $allowed');
    if (allowed) {
      await MobileAds.instance.initialize();
      debugPrint('[Reklam] AdMob başlatıldı');
    }
    return allowed;
  }

  Future<void> _updateConsentInfo() {
    final done = Completer<void>();
    final params = ConsentRequestParameters(
      consentDebugSettings: debugAsEurope
          ? ConsentDebugSettings(debugGeography: DebugGeography.debugGeographyEea)
          : null,
    );
    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      done.complete,
      (error) {
        // Bilgi alınamazsa (örn. internet yok) eski onay durumuyla devam edilir.
        debugPrint('Onay bilgisi alınamadı: ${error.message}');
        done.complete();
      },
    );
    return done.future;
  }

  Future<void> _showFormIfRequired() {
    final done = Completer<void>();
    ConsentForm.loadAndShowConsentFormIfRequired((error) {
      if (error != null) debugPrint('Onay formu: ${error.message}');
      done.complete();
    });
    return done.future;
  }

  @override
  Future<bool> privacyOptionsRequired() async =>
      await ConsentInformation.instance.getPrivacyOptionsRequirementStatus() ==
      PrivacyOptionsRequirementStatus.required;

  @override
  Future<void> showPrivacyOptions() {
    final done = Completer<void>();
    ConsentForm.showPrivacyOptionsForm((error) {
      if (error != null) debugPrint('Gizlilik seçenekleri: ${error.message}');
      done.complete();
    });
    return done.future;
  }
}
