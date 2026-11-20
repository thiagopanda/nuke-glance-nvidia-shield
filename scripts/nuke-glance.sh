#!/usr/bin/env bash
# Kill it: switch the screensaver away from Google's Backdrop and stop Backdrop.
# Usage: bash scripts/nuke-glance.sh <SHIELD_IP> [--full]
#   --full                 optional full nuke: also disable Backdrop entirely
#   SCREENSAVER=pkg/.Svc   pick your own screensaver
set -euo pipefail
IP="${1:?Usage: $0 <SHIELD_IP> [--full]}"
FULL="${2:-}"
DEV="${IP}:5555"

adb connect "$DEV" >/dev/null

if [ -z "${SCREENSAVER:-}" ]; then
  if adb -s "$DEV" shell pm list packages | grep -q '^package:com.omarchytv.home$'; then
    SCREENSAVER="com.omarchytv.home/.OmarchyDream"
  else
    SCREENSAVER="com.android.dreams.basic/.Colors"
  fi
fi

echo "Switching screensaver to $SCREENSAVER"
adb -s "$DEV" shell settings put secure screensaver_components "$SCREENSAVER"
adb -s "$DEV" shell settings put secure screensaver_default_component "$SCREENSAVER"
adb -s "$DEV" shell am force-stop com.google.android.backdrop

if [ "$FULL" = "--full" ]; then
  echo "Optional full nuke: disabling Backdrop entirely"
  adb -s "$DEV" shell pm disable-user --user 0 com.google.android.backdrop
fi

echo "Now: $(adb -s "$DEV" shell settings get secure screensaver_components)"
echo "Done. Undo any time with: bash scripts/undo.sh $IP"
