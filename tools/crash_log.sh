#!/usr/bin/env bash
# Android çökme kaydı: telefonda uygulamayı açar, çöküş kaydını toplar.
# Telefon USB ile bağlı ve USB hata ayıklama açık olmalı; uygulama yüklü olmalı.
# Kullanım (proje kökünden): tools/crash_log.sh
set -uo pipefail
cd "$(dirname "$0")/.."

# adb: önce PATH, sonra projenin Android SDK'sı (android/local.properties).
SDK_DIR="$(sed -n 's/^sdk.dir=//p' android/local.properties 2>/dev/null)"
ADB="$(command -v adb || echo "${SDK_DIR:-$HOME/Library/Android/sdk}/platform-tools/adb")"
PKG="com.karanlikoda.karanlik_oda"
OUT="build/crash_log.txt"
mkdir -p build

"$ADB" devices
"$ADB" logcat -c
echo "Uygulama açılıyor..."
"$ADB" shell monkey -p "$PKG" -c android.intent.category.LAUNCHER 1 >/dev/null 2>&1
sleep 8

{
  echo "=== crash buffer ==="
  "$ADB" logcat -d -b crash
  echo
  echo "=== uygulama ve hata satırları ==="
  "$ADB" logcat -d | grep -iE "AndroidRuntime|FATAL|flutter|$PKG|ClassNotFound|NoSuchMethod|UnsatisfiedLink|jni|Exception" | tail -300
} > "$OUT"

echo "Kayıt yazıldı: $OUT ($(wc -l < "$OUT") satır)"
