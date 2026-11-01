import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/audio/audio.dart';
import 'core/dev_flags.dart';
import 'core/di/providers.dart';
import 'core/storage/storage.dart';
import 'features/ads/data/repositories/admob_interstitial_ads.dart';
import 'features/ads/data/repositories/admob_platform.dart';
import 'features/ads/data/repositories/admob_rewarded_ads.dart';
import 'features/content/data/datasources/case_json_datasource.dart';
import 'features/content/data/repositories/content_repository_impl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Oyun dikey oynanır.
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Cihazdaki kayıt kutularını aç (hesap yok; her şey cihazda).
  final storage = await Storage.init();

  // Dosyaların içeriği (hikâye, bulmacalar, fotoğraflar) pakette JSON olarak durur.
  ContentRepository library;
  try {
    library = await ContentRepositoryImpl.load(CaseJsonDataSource(rootBundle));
  } catch (e, st) {
    // İçerik dosyası bozuksa uygulama yine açılsın; ekranlar örnek içeriğe düşer.
    FlutterError.reportError(
        FlutterErrorDetails(exception: e, stack: st, library: 'content'));
    library = ContentRepositoryImpl.empty;
  }

  // Efektler ve karanlık oda ortam sesi. Yüklenemezse oyun sessiz açılır.
  final audio = await AudioplayersAudio.create();

  // Reklamlar (Google AdMob). Onay ve başlatma açılış sahnesinden sonra yapılır
  // (bkz. adsStartupProvider); o zamana kadar hiçbir reklam istenmez.

  runApp(
    ProviderScope(
      overrides: [
        storageProvider.overrideWithValue(storage),
        contentRepositoryProvider.overrideWithValue(library),
        gameAudioProvider.overrideWithValue(audio),
        adsPlatformProvider.overrideWithValue(
            AdmobPlatform(debugAsEurope: kDevConsentAsEurope)),
        rewardedAdsProvider.overrideWithValue(AdmobRewardedAds()),
        interstitialAdsProvider.overrideWithValue(AdmobInterstitialAds()),
      ],
      child: const DarkRoomApp(),
    ),
  );
}
