import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

/// AdMob reklam birimi kimlikleri.
///
/// Geliştirme ve test sürümlerinde her zaman Google'ın test reklamları kullanılır:
/// kendi gerçek reklamına tıklamak AdMob hesabını kapattırabilir. Gerçek kimlikler
/// yalnızca mağaza (release) sürümünde devreye girer.
abstract final class AdUnitIds {
  static bool get _useTestAds => !kReleaseMode;

  static String get rewarded => _pick(
        iosReal: 'ca-app-pub-6761505522094912/2106517998',
        androidReal: 'ca-app-pub-6761505522094912/8029937673',
        iosTest: 'ca-app-pub-3940256099942544/1712485313',
        androidTest: _androidTestRewarded,
      );

  static String get interstitial => _pick(
        iosReal: 'ca-app-pub-6761505522094912/2133991044',
        androidReal: 'ca-app-pub-6761505522094912/6754842469',
        iosTest: 'ca-app-pub-3940256099942544/4411468910',
        androidTest: _androidTestInterstitial,
      );

  static const _androidTestRewarded = 'ca-app-pub-3940256099942544/5224354917';
  static const _androidTestInterstitial =
      'ca-app-pub-3940256099942544/1033173712';

  static String _pick({
    required String iosReal,
    required String androidReal,
    required String iosTest,
    required String androidTest,
  }) {
    if (Platform.isIOS) return _useTestAds ? iosTest : iosReal;
    return _useTestAds ? androidTest : androidReal;
  }
}
