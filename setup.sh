#!/bin/sh
# Karanlık Oda · ilk kurulum
# Kullanım: Terminal'de proje klasöründe  sh setup.sh
set -e

echo "1/4 · Android ve iOS klasörleri oluşturuluyor (var olan dosyalara dokunulmaz)…"
flutter create --org com.karanlikoda --project-name karanlik_oda --platforms android,ios .

echo "2/4 · Paketler ekleniyor…"
flutter pub add flutter_riverpod go_router hive_ce hive_ce_flutter \
  freezed_annotation json_annotation flutter_animate flutter_svg

echo "3/4 · Geliştirici paketleri ekleniyor…"
flutter pub add --dev build_runner freezed json_serializable flutter_lints mocktail

echo "4/4 · Kontrol…"
flutter pub get
flutter analyze || echo "(Analiz uyarıları var; çalışmaya engel değil.)"
flutter test

echo ""
echo "Hazır. Çalıştırmak için:  flutter run"
