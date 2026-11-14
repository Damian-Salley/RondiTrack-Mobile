# Assignment 10.2 Completion Report

**Verification date:** 13 November 2026. Branch: `feature/assignment-10.2`.
No commit, push, merge, pull request or hosted CI run was performed.

## Implementation

- Typed go_router stateful shell: Home, Stokvels, Activity, Profile; independent
  stacks and retained scroll. Nested cycle addresses build both parent pages.
- Riverpod fake email authentication, one pure redirect, router refresh listener,
  safe remembered internal destinations, invite preview/fake Join and sign-out.
- Separate Android schemes per flavour; invalid IDs, non-members and mismatched
  cycles receive not-found responses. Existing per-membership action rules remain.
- Material 3 light/dark system themes, status ThemeExtension, measured contrast,
  shared window breakpoints, compact bottom bar, rail and expanded list/detail.
- Existing models, money, fake repositories, business rules and flavour config
  preserved. The old persona selector moved from Home to email sign-in.

## Automated checks actually run

| Check | Result |
|---|---|
| `dart format --output=none --set-exit-if-changed .` | Passed, 49 files unchanged |
| `dart analyze --fatal-infos` | Passed, no issues |
| `flutter test` | Passed, 83 tests, including all 63 existing tests |
| `dart run build_runner build`, repeated | Passed; generated-file hashes unchanged |
| Dev / staging / prod Android debug APKs | All three built successfully |
| Presentation search for literal colours and Navigator.push | No matches |
| Router package age | Cached pub.dev publication metadata: 18.1.1 on 20 October; 4.5.2 on 19 October 2026 |

New tests cover redirects and rejected external destinations, invite continuation,
sign-out back isolation, invalid/non-member resources, mismatched cycles,
per-Stokvel roles, retained cycle stack/scroll, Activity's four states, 360×640 at
200% text, tablet panes/resize/back, and light/dark contrast. The original
one-frame switching test now drives the real router and retains its assertions.

## Local verification

```bash
flutter pub get --enforce-lockfile
dart run build_runner build
dart format --output=none --set-exit-if-changed .
dart analyze --fatal-infos
flutter test
flutter build apk --debug --flavor dev --dart-define-from-file=config/dev.json
flutter build apk --debug --flavor staging --dart-define-from-file=config/staging.json
flutter build apk --debug --flavor prod --dart-define-from-file=config/prod.json
```

Deep-link commands for all three link types and flavours, route/back decisions,
theme measurements and breakpoints are in the [README](../README.md).
Device evidence and capture instructions are in
[Assignment 10.2 evidence](evidence/assignment-10.2/README.md).

## Android evidence and remaining submission work

Actual Android API 34 emulator captures include Home and stokvel in light/dark,
360 dp at 200% text (Home, list, detail and reachable actions), an expanded tablet
window, non-member and invalid-resource not-found screens, and both required
recordings. Checkpoint screenshots verify cold cycle → stokvel → list and invite
sign-in → original preview → fake Join confirmation. Size, density and font were
reset; run `adb shell cmd uimode night auto` when restarting the AVD to restore
automatic night mode (the emulator stopped before that final reset reached it).
All three final APKs were installed together, and all nine link/flavour intent
resolutions selected the correct package (`android-intents.txt`).

Remaining: owner review of recordings, optional physical-device/gesture checks,
full staging/prod cold-and-warm sign-in walkthroughs (only intent resolution was
checked for those flavours), and owner-controlled PR submission/hosted CI. There
are no known failing automated checks. Real API authentication, membership
mutation and payment actions remain outside this assignment's fake flow.

## Files

Created: `lib/app/{router.dart,router.g.dart,auth_redirect.dart,app_theme.dart}`;
`lib/core/breakpoints.dart`; `lib/features/activity/activity_screen.dart`;
`lib/features/session/presentation/{auth_provider.dart,sign_in_screen.dart,profile_screen.dart}`;
`lib/features/stokvels/presentation/{stokvel_list_screen.dart,join_screen.dart}`;
`test/{navigation_test.dart,layout_theme_test.dart,activity_test.dart}`;
`docs/evidence/assignment-10.2/` evidence and capture guide.

Modified: `pubspec.yaml`, `pubspec.lock`, `README.md`, this report,
`android/app/build.gradle.kts`, `android/app/src/main/AndroidManifest.xml`,
`lib/app/ronditrack_app.dart`, Home and detail screens,
`lib/features/session/domain/persona.dart`, `test/widget_test.dart`.
Existing generated sources were regenerated without content changes.

---

# Assignment 10.1 Completion Report (historical)

**Verification date:** 10 November 2026
**Backend:** Committed, pushed, PR created, CI green.
**Mobile:** Implementation and local verification complete; commit, PR and hosted CI verification pending.

## 1. Backend submission

**Repository:** https://github.com/Damian-Salley/RondiTrack

**Branch:** `feature/assignment-10.1-backend`

**Commit:** `1e23b75266a0e56f1e3658c84fc54fb8af29c9fd`

**Pull request:** https://github.com/Damian-Salley/RondiTrack/pull/6

**Status:** All GitHub CI checks passed, as confirmed by the repository owner.

The backend changes were reviewed, committed and pushed separately from the Flutter application.

### Backend changes

- Added exact integer-cent monetary conversion.
- Added validation for monetary inputs.
- Extended stokvel and contribution-cycle API responses.
- Added contribution confirmation with authorization and status checks.
- Added the third development seed persona.
- Updated the OpenAPI contract.
- Added automated regression tests.
- Updated backend documentation.

### Backend verification

| Check | Result |
|---|---|
| Full automated test suite | 108 passed |
| Focused monetary tests | 24 passed |
| OpenAPI JSON validation | Passed |
| Git whitespace validation | Passed |
| Backend commit | Complete |
| Backend push | Complete |
| Backend PR | Created |
| GitHub CI | Green |
| Merge | Not claimed |

The full backend suite ran with PostgreSQL test containers available.

Test collections were executed sequentially to manage container memory.

Evidence:

- [Full backend test suite](evidence/backend-full-suite.txt)
- [Focused monetary tests](evidence/backend-money-tests.txt)

## 2. Flutter verification

**Repository:** RondiTrack-Mobile

**Branch:** `feature/assignment-10.1`

### Confirmed results

| Check | Result |
|---|---|
| Flutter analysis | No issues found |
| Automated Flutter tests | 63 passed |
| Development Android APK | Built successfully |
| Development configuration | Reviewed |
| Staging configuration | Reviewed |
| Production configuration | Reviewed |
| Contract provenance | Updated |
| OpenAPI SHA-256 | Verified |
| Flutter commit | Pending |
| Flutter PR | Pending |
| Flutter GitHub CI | Pending |

### Flutter analysis

Command:

```bash
flutter analyze
```

Result:

```text
No issues found!
```

### Flutter automated tests

Command:

```bash
flutter test
```

Result:

```text
00:18 +63: All tests passed!
```

The suite includes monetary, domain, provider, state-management and widget tests.

Evidence:

[Flutter test results](evidence/mobile-tests.txt)

### Android development build

Command:

```bash
flutter build apk --debug --flavor dev --dart-define-from-file=config/dev.json
```

Result:

```text
Built build/app/outputs/flutter-apk/app-dev-debug.apk
```

The development APK was built successfully.

The staging and production debug APKs were also previously verified locally.

An explicit `--flavor` is required because the native build validates the selected environment.

These are Android debug builds. Production signing, store distribution and iOS builds are not claimed.

## 3. Compulsory requirement checklist

| Compulsory requirement | Result and evidence |
|---|---|
| Read entire assignment before editing | Completed; initial checklist and review delivered before changes |
| Inspect mobile project and backend README/OpenAPI | Completed; reviewed original backend commit and identified contract gaps |
| Flutter 3.47.7 / Dart 3 | Verified Flutter 3.47.7 and Dart 3.13.5; Android toolchain available |
| Root Android/iOS project with own organisation | Implemented; organisation `za.co.damiansalley`; Android verified, iOS not verified |
| Feature-first architecture | Implemented using app, core and features |
| Development, staging and production identifiers | Implemented; three Android flavors configured |
| Separate launcher names | Implemented and locally demonstrated |
| Nonsecret configuration files | Implemented; development uses emulator address; staging and production use documented placeholders |
| Reject missing/mismatched configuration | Implemented and tested; invalid native builds fail |
| Exact dependency versions and lockfile | Implemented; required dependency versions pinned |
| Dependency publication-age requirement | Previously audited; evidence retained |
| Strict lint configuration | Implemented; strict Dart analysis previously verified locally |
| Riverpod analyzer plugin | Configured; local lint failure evidence recorded |
| Pull-request CI workflow | Implemented; hosted mobile execution pending |
| Backend contract and source revision | Updated; committed backend SHA and PR recorded |
| Generated Android build files excluded | Implemented through Android ignore rules |
| Generated-code policy | Generated Dart files and lockfile retained for commit |
| Red Riverpod CI run followed by green run | Local lint failure demonstrated; hosted red-to-green evidence still pending |
| Integer Cents domain type | Implemented; monetary domain fields use Cents |
| Backend decimal validation | Implemented and tested |
| Exact cents conversion | Implemented; rejects invalid precision and overflow |
| en-ZA formatter and parser | Implemented and tested |
| Exact API status values | Implemented and tested |
| Unknown status fallback | Implemented; unknown values suppress dependent actions |
| Freezed domain models | Implemented and generated |
| Membership role per stokvel | Implemented and tested |
| Exhaustive action matching | Implemented and tested |
| Added-status compiler experiment | Completed; diagnostics retained |
| Repository interfaces and fakes | Implemented |
| Three development personas | Implemented |
| Adjustable fake delays | Implemented |
| Repository binding outside widgets | Implemented |
| Home AsyncNotifier | Implemented |
| One Home card per membership | Implemented |
| Server-supplied monetary values | Represented in fake data and domain models |
| Nullable payout display | Implemented |
| Pull-to-refresh retaining cards | Implemented and tested |
| Detail provider family keyed by ID | Implemented |
| Detail cycle, contributions and actions | Implemented |
| Four sealed view states | Implemented and tested |
| Exhaustive state rendering | Implemented |
| Failure retry | Implemented and tested |
| Inaccessible and nonexistent detail | Both display `Stokvel not found.` |
| Stokvel picker | Implemented |
| Slow-B loading without stale A contributions | Implemented and widget-tested |
| Provider lifetime decisions | Documented |
| Future sign-out isolation plan | Documented |
| Provider disposal evidence | Captured |
| Separate family states | Tested |
| Shared fetch for multiple listeners | Tested |
| Riverpod retry disabled in failure tests | Implemented |
| Flutter automated test suite
