# How Glance was found

Date: November 19, 2026. Setup: NVIDIA Shield TV on HDMI 2 of an LG webOS TV, driven over network ADB from a Linux box (Omarchy) on the same LAN / Tailscale.

## Symptom

A Glance screen kept appearing as the screensaver: AI-generated images with "Show Me Here", like/dislike, an "Image: AI Generated" label, and a "Glance Global Privacy Policy" page (glance.com/tv-policy-us).

## What was ruled out

- **The LG TV.** Its Screen Saver Promotion setting (All Settings → General → System → Additional Settings) was already off. Listing every app on the LG over its local API showed no Glance app. The LG was on HDMI 2, which is the Shield, so the screen came from the Shield.
- **A Glance app on the Shield.** `pm list packages -u` (including disabled and uninstalled packages) had nothing named Glance. No third-party app (Aptoide TV, TCL Browser, Projectivy, file managers, etc.) contained Glance code.
- **Overlays / accessibility.** No accessibility services were enabled and only Google's own assistant had overlay permission.

## The giveaway

The screensaver was Google's Backdrop:

```
$ adb -s <SHIELD_IP>:5555 shell settings get secure screensaver_components
com.google.android.backdrop/.Backdrop
```

And its process logged a Glance component:

```
$ adb -s <SHIELD_IP>:5555 shell 'logcat -d | grep -i glance'
W GlanceWorkerFactory: worker created as Glance is enabled

$ adb -s <SHIELD_IP>:5555 shell 'ps -A -o PID,NAME | grep <PID_FROM_LOG>'
<PID> com.google.android.backdrop
```

So Glance rides inside Backdrop (Ambient Mode). The fix is to stop using Backdrop as the screensaver, or to disable it entirely. See the [README](../README.md).
