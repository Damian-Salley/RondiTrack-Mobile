# Assignment 10.2 evidence

Capture real emulator/device output only. Do not use widget-test images as phone
evidence. The completion report distinguishes automated checks from device checks.

## Captured on 13 November 2026

The files listed below were captured from the final dev debug APK on the installed
Android API 34 emulator using software graphics. Screenshots are unedited native
`screencap` output. Both videos are native `screenrecord` output, recorded at
540×1200 to reduce emulator load. Review video playback before attaching to a PR.
Checkpoint screenshots additionally show the cold sign-in, cycle, both back
targets, invite preview and fake Join confirmation.

The 360 dp captures used 720×1280 pixels at density 320 and font scale 2.0. The
tablet capture used 1920×1280 pixels at density 240 (1280×853 dp). Size, density
and font overrides were restored after capture. Night mode was last set to light;
the emulator stopped before the final `night auto` reset could reach it. Run the
reset command below when restarting this AVD.

`android-intents.txt` records actual resolution of all nine required link/flavour
combinations with all three APKs installed together. This establishes flavour
targeting, not a full staging/prod sign-in walkthrough. Dev cold cycle, invite
authentication, warm links, non-member/invalid screens and layouts were exercised.

## Required captures

| File | Show |
|---|---|
| `home-light.png`, `stokvel-light.png` | Demo Member Home and Community Savings in light mode |
| `home-dark.png`, `stokvel-dark.png` | Same screens in dark mode |
| `small-200-percent.png` | 360 dp width and 200% font size; scroll to check all actions |
| `tablet.png` | At least 840 dp wide, Stokvel list and addressed detail together |
| `cold-cycle.mp4` | Force-stop, open cycle address, sign in, back to stokvel then list |
| `invite-sign-in.mp4` | Signed out, open invite, sign in, original preview and Join |
| `non-member-not-found.png` | New Member opening stokvel 1, showing Stokvel not found |

Use the README's nine link commands to test each flavour, cold and warm. Staging
and prod are separate installs, so use their own scheme and package when testing.
Use Demo Member to compare Community Savings treasurer actions with Family Savings
member actions. Compare New Member at stokvel 1 with invalid stokvel 999 and
cycles 101/999; all denied resources must use the corresponding not-found message.

## Capture commands

Use Android Studio's Device Manager or an existing emulator. From PowerShell, if
adb is not on PATH, first set:

```powershell
$env:Path += ";$env:LOCALAPPDATA\Android\Sdk\platform-tools"
flutter run --flavor dev --dart-define-from-file=config/dev.json
```

In another terminal:

```bash
adb shell cmd uimode night no
adb shell screencap -p /sdcard/home-light.png
adb pull /sdcard/home-light.png docs/evidence/assignment-10.2/home-light.png
adb shell cmd uimode night yes
# Navigate to each screen, then repeat screencap/pull with the matching filename.

# 720 physical pixels / density 320 = 360 dp, 1280 pixels = 640 dp.
adb shell wm size 720x1280
adb shell wm density 320
adb shell settings put system font_scale 2.0
# Capture the small screen and scroll through every action.

# 1920x1280 at density 240 gives 1280x853 dp, an expanded window.
adb shell settings put system font_scale 1.0
adb shell wm size 1920x1280
adb shell wm density 240
# Open stokvel 1, capture tablet.png, then resize/rotate and press back.

# Restore device settings after testing.
adb shell wm size reset
adb shell wm density reset
adb shell settings put system font_scale 1.0
adb shell cmd uimode night auto
```

For each recording, start this in one terminal (Ctrl+C stops and saves it):

```bash
adb shell screenrecord /sdcard/cold-cycle.mp4
```

In another terminal, force-stop and launch the dev cycle link from the README,
sign in using `assignment71-demo@ronditrack.example`, then use Android back twice.
Stop recording and pull it:

```bash
adb pull /sdcard/cold-cycle.mp4 docs/evidence/assignment-10.2/cold-cycle.mp4
```

Repeat as `invite-sign-in.mp4`, starting signed out and opening
`ronditrack-dev://app/join/family`. Show sign-in, `Invite code: family`, then Join.
Attach the actual files to the owner's PR, titled
`Assignment 10.2: Every Screen Has an Address`. Hosted CI and submission remain
the owner's responsibility; this task does not commit, push or open a PR.
