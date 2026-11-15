# Assignment 10.3 evidence

Captured/verified on 14 November 2026. Files contain actual tool, test and Android
emulator output. No screenshots or videos were generated from widget tests.

## Automated checks

- `final-tests.txt`: all **134 mobile tests passed** after restoring mutations.
- `final-analysis.txt`: `dart analyze --fatal-infos`, no issues.
- `final-format.txt`: formatter check, no changes.
- `locked-dependencies.txt`: enforced lockfile resolution succeeded. Manifest
  and lockfile are unchanged from main; the existing dependency-age audit still
  covers every pinned package. No app packages were added.
- `generation-first.txt`, `generation-second.txt`, `generation-check.txt`:
  successful regeneration twice, identical second-run hashes, generated files
  match committed sources.
- `backend-tests.txt`: **109/109 backend tests passed**, PostgreSQL integration
  included; `/openapi/v1.json` exported from that application. See
  `contract/provenance.json` for its commit and hash.
- Per-layer `*-analysis.txt`, `*-tests.txt` and `*-format.txt` correspond to the
  separate green commits listed in the completion report.
- `red-unknown-status.txt`, `red-membership.txt`, `red-architecture-colour.txt`:
  three deliberately broken implementations caused real assertion failures.
  `red-membership-reload.txt` is the additional real regression found and fixed.
  These are expected red results, not outstanding failures.

## Android builds

| Log | Result |
|---|---|
| `android-dev-debug.txt` | Passed, dev debug APK |
| `android-staging-debug.txt` | Passed, staging debug APK |
| `android-prod-debug.txt` | Passed, prod debug APK |
| `android-prod-release.txt` | Passed, prod release APK (48.7 MB) |

Each build uses `--flavor <flavor>` and its matching
`--dart-define-from-file=config/<flavor>.json`. Release retains the repository's
existing assignment/debug signing, not store publishing credentials. Flutter's
release tool emitted a Cupertino font-discovery warning; the build succeeded
and this app uses Material icons. No package was added to silence that warning.

## Real phone screenshots and recording

Android API 34 AVD, software graphics. Dev captures use the final dev debug APK;
the prod comparison uses the final **prod release** APK. Standard captures use
720×1600 pixels at density 320 (360×800 dp), font scale 1.0. Screenshots are
unedited native `adb shell screencap -p` output.

| File | Observed content |
|---|---|
| `payouts-lerato.png` | Lerato: order, rand amounts, Next/Waiting words and Record payout |
| `payouts-sipho.png` | Same server order under Sipho, no Record payout |
| `home-new-member.png` | New Member's empty Home with invite guidance |
| `profile-dev-switcher.png` | Dev Profile with the three-person menu open |
| `profile-prod.png` | Same Profile in prod release, no switcher |
| `family-lerato.png`, `family-sipho.png` | Mabena Family's scoped Member role; own actions differ by contribution |
| `family-not-found.png` | New Member at the same Family address gets Stokvel not found |
| `payouts-dark.png` | Actual system dark theme and payout tokens |
| `payouts-200-percent-top.png`, `payouts-200-percent-actions.png` | 720×1280/density 320 = 360×640 dp, Android font scale 2.0; scroll exposes every row/action without overflow |
| `persona-switch.mp4` | Native screenrecord: Family remains open while Lerato switches to Sipho; ends during a further New Member switch |

The recording is unedited H.264, 540×1200, 19.95 seconds. The complete stream
decoded successfully (89 variable-rate frames); representative extracted frames
were visually inspected. `video-verification.txt` contains actual decoder
output. Extracted inspection frames and tooling are ignored, not submission
artifacts. Full-speed playback review is also advisable when attaching the video.

The Family contribution list intentionally includes Lerato's contribution when
Sipho views it: the API permits members to see group contributions. Sipho has no
own Family contribution, so his action is Pay rather than Lerato's Upload proof.
The automated first-frame tests verify the old list disappears while the new
membership loads; shared group rows may then legitimately appear again.

`android-device.txt` records a successful **cold** dev payout launch, sign-in
restoration, native UI assertions for payouts → cycle → stokvel, and Android
resolution of all three payout schemes with the flavours installed together.
Staging is build/intent-resolution and widget-tested; no staging sign-in
walkthrough is claimed. The prod release Profile was opened through its own
scheme and email sign-in, without seed shortcuts.

An early overloaded emulator session stalled in Android System UI. It was
restarted with two cores after builds finished; those failed captures were not
retained as evidence. The captures above were visually inspected. Font scale,
size, density and night-mode overrides were restored after capture.

## Submission

Hosted CI and PR links are deliberately pending the owner's review/publication.
No push, merge or pull request was performed. Use the prepared PR description,
attach these real files and add the eventual green CI run and backend PR link.
