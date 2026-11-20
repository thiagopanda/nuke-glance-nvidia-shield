#!/usr/bin/env bash
# Undo: re-enable Backdrop and make it the screensaver again.
# Usage: bash scripts/undo.sh <SHIELD_IP>
set -euo pipefail
IP="${1:?Usage: $0 <SHIELD_IP>}"
DEV="${IP}:5555"

adb connect "$DEV" >/dev/null
adb -s "$DEV" shell pm enable com.google.android.backdrop
adb -s "$DEV" shell settings put secure screensaver_components com.google.android.backdrop/.Backdrop
echo "Now: $(adb -s "$DEV" shell settings get secure screensaver_components)"
