#!/usr/bin/env bash
# Finding the culprit: show the active screensaver and any Glance activity in the log.
# Usage: bash scripts/find-glance.sh <SHIELD_IP>
set -euo pipefail
IP="${1:?Usage: $0 <SHIELD_IP>}"
DEV="${IP}:5555"

adb connect "$DEV" >/dev/null
echo "== Active screensaver"
adb -s "$DEV" shell settings get secure screensaver_components

echo "== Glance in the log"
LOG="$(adb -s "$DEV" shell 'logcat -d | grep -i glance' || true)"
if [ -z "$LOG" ]; then
  echo "(no Glance lines in the current log; let the screensaver run, then try again)"
else
  echo "$LOG"
  echo "== Process behind it"
  for PID in $(echo "$LOG" | awk '{print $3}' | sort -u); do
    adb -s "$DEV" shell "ps -A -o PID,NAME | grep -E '^ *$PID '" || true
  done
fi

echo "== Screensavers installed on this TV"
adb -s "$DEV" shell pm query-services -a android.service.dreams.DreamService \
  | grep -E '^ +name=' | sed 's/^ *name=//'
