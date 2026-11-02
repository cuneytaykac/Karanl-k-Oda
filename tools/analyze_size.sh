#!/usr/bin/env bash
# Uygulama boyutu analizi (Android, arm64).
# Kullanım (proje kökünden):
#   tools/analyze_size.sh          -> önce AAB, sonra APK
#   tools/analyze_size.sh aab      -> yalnızca AAB
#   tools/analyze_size.sh apk      -> yalnızca APK
# Çıktılar ayrıca build/size_reports/ altına kaydedilir.
set -euo pipefail

cd "$(dirname "$0")/.."
mode="${1:-all}"
out="build/size_reports"
mkdir -p "$out"
stamp="$(date +%Y%m%d_%H%M%S)"

run() {
  local kind="$1"
  local log="$out/${kind}_${stamp}.txt"
  echo
  echo "=============================================="
  echo " $kind boyut analizi (android-arm64)"
  echo "=============================================="
  flutter build "$kind" --release --analyze-size --target-platform android-arm64 2>&1 | tee "$log"
  echo
  echo "-> Rapor kaydedildi: $log"
}

case "$mode" in
  aab) run appbundle ;;
  apk) run apk ;;
  all) run appbundle; run apk ;;
  *) echo "Bilinmeyen seçenek: $mode (aab | apk | boş bırak)"; exit 1 ;;
esac

echo
echo "Dosya boyutları:"
ls -lh build/app/outputs/bundle/release/*.aab 2>/dev/null || true
ls -lh build/app/outputs/flutter-apk/app-release.apk 2>/dev/null || true
echo
echo "Ayrıntılı inceleme için: dart devtools ile çıktıda yazan *-code-size-analysis_*.json dosyasını açın."
