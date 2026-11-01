# Karanlık Oda

Nonogram + gizem mobil oyunu (Flutter · Android ve iOS).

## İlk kurulum (bir kez)

Terminal'i aç, proje klasörüne gir ve kurulum betiğini çalıştır:

```sh
cd ~/Desktop/karanlik_oda
sh setup.sh
```

Betik sırasıyla şunları yapar:
1. `android/` ve `ios/` klasörlerini oluşturur (var olan dosyalara dokunmaz).
2. Paketleri en güncel uyumlu sürümleriyle ekler.
3. `flutter analyze` ve `flutter test` çalıştırır.

Sonra telefonu ya da emülatörü bağlayıp:

```sh
flutter run
```

## Klasör yapısı

```
lib/
  main.dart              uygulama girişi (kayıt kutularını açar)
  app.dart               tema + yönlendirme
  core/
    theme/               renkler, yazı stilleri, ölçüler, ThemeData
    router/              ekran adresleri (go_router)
    storage/               cihazdaki kayıt (hive_ce) — oyunun geri kalanı Hive'ı bilmez
    settings/            oyuncu ayarları + kontrolcüsü (Riverpod)
    widgets/             alt menü, düğmeler, ana iskelet
  engine/                (Aşama 1) saf Dart nonogram motoru
  content/               (Aşama 2) Dosya JSON modelleri ve okuyucu
  progress/              (Aşama 2) oyuncu ilerlemesi
  features/
    developing/ case_files/ notebook/ puzzle/ settings/ ...
assets/
  fonts/                 Lora, Poppins, JetBrains Mono, Caveat (OFL lisansı: fonts/licenses)
  images/             uygulama görselleri
  case_files/<case_id>/   her Dosya'nın JSON'u ve fotoğrafları
```

## Kurallar

- **Renk, yazı, boşluk** yalnızca `core/theme/` içinden kullanılır; ekranlarda elle renk kodu yazılmaz.
- **Hikâye içeriği koda yazılmaz**; `assets/case_files/` altındaki JSON'dan okunur.
- **Bulmaca motoru** (`engine/`) Flutter'ı bilmez; saf Dart'tır ve testle doğrulanır.
- Reklam (`google_mobile_ads`), satın alma (`in_app_purchase`) ve analiz paketleri **Aşama 6'da** eklenecek;
  bu paketler mağaza kimlikleri olmadan uygulamayı açılışta çökertebilir.

## Yol haritası

| Aşama | İçerik | Durum |
|---|---|---|
| 0 | Hazırlık: proje, tema, fontlar, yönlendirme, kayıt, ayarlar | ✅ iskelet hazır |
| 1 | Çekirdek döngü: motor, bulmaca, banyo, inceleme | |
| 2 | İçerik sistemi: JSON, rulo akışı, kayıt | |
| 3 | Uygulama iskeleti + Defter | |
| 4 | İlk tam Dosya (Yanlış Adam) | |
| 5 | Cila: ses, titreşim, animasyon | |
| 6 | Gelir ve yasal: reklam, izin, satın alma, analiz | |
| 7 | Test ve yayın | |
