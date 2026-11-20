# Nuke the Google Glance screensaver on NVIDIA Shield TV

**NVIDIA Shield TV - Google Glance screensaver intrusive crap. NUKE it!**

Glance (the "AI-generated image" lock-screen/screensaver content with "Show Me Here" and like/dislike buttons) kept taking over my NVIDIA Shield TV. It isn't a separate app you can uninstall. It runs inside Google's own **Backdrop** (Ambient Mode) screensaver, `com.google.android.backdrop`.

📣 Original post: [x.com/SirPandaALot/status/2123636752111837223](https://x.com/SirPandaALot/status/2123636752111837223)

---

Here's everything I ran from my Omarchy box. These commands found the culprit.

The Shield is at `<SHIELD_IP>`

> Network ADB has to be on and approved on the TV first.
> (Shield: Settings → Device Preferences → Developer options → Network debugging. Approve the "Allow debugging?" prompt on the TV the first time you connect.)

### Finding the culprit

Glance shows up in the screensaver's log:

```bash
adb connect <SHIELD_IP>:5555
adb -s <SHIELD_IP>:5555 shell settings get secure screensaver_components
adb -s <SHIELD_IP>:5555 shell 'logcat -d | grep -i glance'
adb -s <SHIELD_IP>:5555 shell 'ps -A -o PID,NAME | grep <PID_FROM_LOG>'
```

### Kill it

Kill it by switching the screensaver and stopping Google's Backdrop. Use any screensaver you like here. I used OmarchyTV's own:

```bash
adb -s <SHIELD_IP>:5555 shell settings put secure screensaver_components com.omarchytv.home/.OmarchyDream
adb -s <SHIELD_IP>:5555 shell settings put secure screensaver_default_component com.omarchytv.home/.OmarchyDream
adb -s <SHIELD_IP>:5555 shell am force-stop com.google.android.backdrop
```

If you don't have OmarchyTV, use Android's basic screensaver instead: `com.android.dreams.basic/.Colors`.

### Optional full nuke

Optional full nuke, which disables Backdrop entirely:

```bash
adb -s <SHIELD_IP>:5555 shell pm disable-user --user 0 com.google.android.backdrop
```

### Undo

```bash
adb -s <SHIELD_IP>:5555 shell pm enable com.google.android.backdrop
adb -s <SHIELD_IP>:5555 shell settings put secure screensaver_components com.google.android.backdrop/.Backdrop
```

---

## Scripts (same commands, ready to run)

```bash
git clone https://github.com/thiagopanda/nuke-glance-nvidia-shield.git
cd nuke-glance-nvidia-shield

bash scripts/find-glance.sh <SHIELD_IP>          # finding the culprit
bash scripts/nuke-glance.sh <SHIELD_IP>          # kill it (OmarchyTV screensaver if installed, else basic Colors)
bash scripts/nuke-glance.sh <SHIELD_IP> --full   # kill it + optional full nuke (disable Backdrop)
bash scripts/undo.sh <SHIELD_IP>                 # undo: back to Google's Backdrop
```

Pick a different screensaver with `SCREENSAVER=<package>/<.Service> bash scripts/nuke-glance.sh <SHIELD_IP>`.
List the ones on your TV with `bash scripts/find-glance.sh <SHIELD_IP>` (it prints every installed screensaver).

Requirements: `adb` (Android platform-tools) on Linux, macOS or WSL, and the TV reachable on your network (LAN or Tailscale).

## More

- [docs/HOW-IT-WAS-FOUND.md](docs/HOW-IT-WAS-FOUND.md): the investigation, what was ruled out, and the log line that gave it away.
- [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md): `unauthorized`, Glance coming back, other Android TV / Google TV boxes.
- [OmarchyTV](https://github.com/piermark/omarchytv): the MIT open-source TV launcher whose screensaver I switched to.

## Credits

Kudos to my Grok Bot, **OmarchyTV Installer II**, for hunting Glance down and nuking it from my Omarchy box. 🫡

Keywords: NVIDIA Shield, Android TV, Google TV, Glance, Glance TV, Glance screensaver, remove Glance, disable Glance, Ambient Mode, Backdrop, com.google.android.backdrop, adb, screensaver ads, AI-generated screensaver.

## License

MIT. Use at your own risk; everything here is reversible with `bash scripts/undo.sh`.
