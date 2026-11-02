#!/usr/bin/env bash
# Android release derlemesi (küçük boyut).
# Kullanım (proje kökünden):
#   tools/build_release.sh apk   -> arkadaş testi: telefona kurulacak APK'lar
#   tools/build_release.sh aab   -> mağaza: Google Play'e yüklenecek AAB
#   tools/build_release.sh       -> ikisi birden
#
# - Her işlemci türü için ayrı APK (--split-per-abi): emülatör (x86_64) yok,
#   arm64 bugünkü telefonların neredeyse hepsi, arm eski telefonlar için.
# - Dart sembolleri APK/AAB'den ayrılır (--obfuscate --split-debug-info):
#   kod küçülür. Semboller build/symbols/<sürüm>/ altında saklanır; çökme
#   kayıtlarını okumak için gerekir (flutter symbolize). SİLMEYİN.
set -euo pipefail
cd "$(dirname "$0")/.."

mode="${1:-all}"
version="$(sed -n 's/^version: *//p' pubspec.yaml | tr -d '[:space:]')"
symbols="build/symbols/${version:-dev}"
mkdir -p "$symbols"

common=(--release --obfuscate --split-debug-info="$symbols")

size() { [ -f "$1" ] && printf '  %-62s %s\n' "$1" "$(du -h "$1" | cut -f1)"; }

build_apk() {
  echo "== APK (arm64 + arm, ayrı dosyalar) · sürüm $version"
  flutter build apk "${common[@]}" --split-per-abi \
    --target-platform android-arm,android-arm64
}

build_aab() {
  echo "== AAB (Google Play) · sürüm $version"
  flutter build appbundle "${common[@]}"
}

case "$mode" in
  apk) build_apk ;;
  aab) build_aab ;;
  all) build_apk; build_aab ;;
  *) echo "Bilinmeyen seçenek: $mode (apk | aab | boş bırak)"; exit 1 ;;
esac

apkdir=build/app/outputs/flutter-apk
echo
echo "Çıktılar:"
size "$apkdir/app-arm64-v8a-release.apk"
size "$apkdir/app-armeabi-v7a-release.apk"
size build/app/outputs/bundle/release/app-release.aab
echo
echo "Semboller: $symbols  (saklayın; çökme kaydı çözmek için gerekli)"
if [ "$mode" != "aab" ]; then
  echo
  echo "Telefona kurulacak dosya: $apkdir/app-arm64-v8a-release.apk"
  echo "(Çok eski bir telefon kurmazsa: app-armeabi-v7a-release.apk)"
fi
