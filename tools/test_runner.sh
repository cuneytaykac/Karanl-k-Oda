#!/bin/bash
# Claude için test çalıştırıcı. Açık kaldığı sürece Claude testleri kendisi başlatır.
# Kullanım: bash tools/test_runner.sh   (durdurmak için Ctrl+C)
# Yalnızca aşağıdaki sabit komutlar çalışır; başka bir şey çalıştırılamaz.
cd "$(dirname "$0")/.." || exit 1
OUT=.claude_runs
mkdir -p "$OUT"
echo "Test çalıştırıcı hazır. Pencereyi açık bırak. (Durdurmak: Ctrl+C)"
while true; do
  if [ -f "$OUT/request" ]; then
    ID=$(cat "$OUT/request"); rm -f "$OUT/request" "$OUT/done"
    CMD=$(cat "$OUT/command" 2>/dev/null || echo "analyze_test")
    echo "[$(date +%H:%M:%S)] Çalışıyor: $ID ($CMD)"
    {
      for step in $(echo "$CMD" | tr '+' ' '); do
        case "$step" in
          pubget)  echo "===== PUB GET ====="; flutter pub get 2>&1 ;;
          l10n)    echo "===== GEN-L10N ====="; flutter gen-l10n 2>&1 ;;
          ads)     echo "===== PUB ADD ====="; flutter pub add google_mobile_ads 2>&1 ;;
          format)  dart format lib test ;;
          analyze) echo "===== ANALYZE ====="; flutter analyze 2>&1 ;;
          test)    echo "===== TEST ====="; flutter test --no-pub 2>&1 ;;
          analyze_test) echo "===== ANALYZE ====="; flutter analyze 2>&1; echo "===== TEST ====="; flutter test --no-pub 2>&1 ;;
          format_analyze_test) dart format lib test; echo "===== ANALYZE ====="; flutter analyze 2>&1; echo "===== TEST ====="; flutter test --no-pub 2>&1 ;;
          *) echo "Bilinmeyen adım: $step" ;;
        esac
      done
    } > "$OUT/output.txt" 2>&1
    echo "$ID" > "$OUT/done"
    echo "[$(date +%H:%M:%S)] Bitti: $ID"
  fi
  sleep 2
done
