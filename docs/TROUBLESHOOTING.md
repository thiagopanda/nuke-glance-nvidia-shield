# Troubleshooting

**`adb` says `unauthorized`**
Look at the TV: approve the "Allow network debugging?" prompt (tick "Always allow from this computer"). Then run `adb disconnect <SHIELD_IP>:5555` and connect again.

**`adb connect` fails or times out**
Turn on Settings → Device Preferences → Developer options → Network debugging on the Shield. (Developer options appear after clicking Settings → Device Preferences → About → Build 7 times.) Check the IP under Settings → Device Preferences → About → Status, or use the Tailscale IP.

**Glance came back**
Something set Backdrop / Ambient Mode as the screensaver again (for example picking it in Settings → Device Preferences → Screen saver, or a system update). Run `bash scripts/nuke-glance.sh <SHIELD_IP> --full` so Backdrop is disabled and can't be picked.

**I want Google's photo screensaver back**
Run `bash scripts/undo.sh <SHIELD_IP>`. Glance may come back with it.

**Other Android TV / Google TV devices**
The same commands should work on any device whose screensaver is `com.google.android.backdrop/.Backdrop`. Run `bash scripts/find-glance.sh <IP>` first to confirm. Tested on NVIDIA Shield TV only.

**The TV itself shows Glance (not the streaming box)**
Check which input the TV is on. If no external box is involved, the screensaver is the TV's own: look for a "Screen Saver Promotion" / screensaver ads setting in the TV's menu.
