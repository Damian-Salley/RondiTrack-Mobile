# Assignment 10.1 Completion Report

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