# RondiTrack Mobile — Assignment 11.3

## Routes

All signed-in people share the same four tabs. The auth gate also uses an
internal splash route while restoring.

| Address | Screen and tab | Signed out | Not a member | Android back, including cold links |
|---|---|---|---|---|
| `/sign-in` | Email and password, outside tabs | Stay here | Not applicable | Exit |
| `/register` | Registration form, outside tabs | Stay here | Not applicable | Sign in link |
| `/home` | Home summary, Home | Sign in, then Home | Empty Home | Exit |
| `/stokvels` | Membership list, Stokvels | Sign in, then list | Empty list | Exit |
| `/stokvels/:id` | Stokvel detail, Stokvels | Sign in, then requested detail | Stokvel not found | Stokvel list |
| `/stokvels/:id/cycles/:cycleId` | Cycle detail, Stokvels | Sign in, then requested cycle | Cycle not found, also for mismatched IDs | Parent stokvel, then list |
| `/stokvels/:id/cycles/:cycleId/payouts` | Rotation and payouts, Stokvels | Sign in, then requested payouts | Cycle not found | Parent cycle, then stokvel and list |
| `/activity` | Fake cross-stokvel feed, Activity | Sign in, then Activity | Empty feed | Exit |
| `/profile` | Current persona and sign-out, Profile | Sign in, then Profile | Not applicable | Exit |
| `/join/:code` | Join and open the stokvel | Sign in, then join | Valid invite adds membership | Home |


## Authentication gate

The app opens a splash while checking secure storage and restoring an existing
session. Sign in accepts an email and password. The dev picker fills in only the
email. Sign out from Profile to switch accounts.

`authRedirect` is one pure, unit-tested gate. Protected addresses go to sign-in
with an encoded `from`; signing in restores that address. `safeDestination`
accepts only known internal routes without schemes, authorities, queries,
fragments or backslashes. Everything else falls back to Home. Our Android custom
scheme links are reduced to their internal path before remembering them.
Riverpod auth changes notify `GoRouter.refreshListenable`, so the gate runs even
without navigation. Sign-out removes the shell and its stacks and invalidates
the session's repositories.

An invite opened before sign-in survives the splash and registration. A
successful join opens the stokvel. The app shares one join operation per code
within the current session.

## Navigation and Android back

Each typed stateful-shell branch keeps its page and scroll. Tapping the active
tab also preserves its position. Back pops the current branch: cycle → stokvel →
list. At a branch root, back exits; it does not replay tab selections. Cold cycle
links build both parents underneath. Invite back goes Home. After sign-out, back
cannot reopen protected screens.

Missing and inaccessible resources give the
same response: `Stokvel not found.` or `Cycle not found.`. Cycles must belong to
their addressed stokvel. The unchanged domain action rules use each stokvel's
membership, never a global persona role.

## Deep links

Custom schemes with host `app` keep installed flavours separate: `ronditrack-dev`,
`ronditrack-staging`, and `ronditrack`. Flutter's native handler forwards cold and
running-app links to the router. Build/install the matching flavour first.
These commands let Android resolve the scheme. Set `INVITE_CODE` to a valid
invite returned by
`POST /api/v1/stokvels/{stokvelId}/invites` on the API for the chosen flavour.

```bash
# Dev
adb shell am start -W -a android.intent.action.VIEW -d "ronditrack-dev://app/stokvels/1"
adb shell am start -W -a android.intent.action.VIEW -d "ronditrack-dev://app/stokvels/1/cycles/101"
adb shell am start -W -a android.intent.action.VIEW -d "ronditrack-dev://app/join/$INVITE_CODE"
# Staging
adb shell am start -W -a android.intent.action.VIEW -d "ronditrack-staging://app/stokvels/1"
adb shell am start -W -a android.intent.action.VIEW -d "ronditrack-staging://app/stokvels/1/cycles/101"
adb shell am start -W -a android.intent.action.VIEW -d "ronditrack-staging://app/join/$INVITE_CODE"
# Prod
adb shell am start -W -a android.intent.action.VIEW -d "ronditrack://app/stokvels/1"
adb shell am start -W -a android.intent.action.VIEW -d "ronditrack://app/stokvels/1/cycles/101"
adb shell am start -W -a android.intent.action.VIEW -d "ronditrack://app/join/$INVITE_CODE"
```

For a **cold** test, force-stop the matching package immediately before each link:

```bash
adb shell am force-stop za.co.damiansalley.ronditrack_mobile.dev
adb shell am force-stop za.co.damiansalley.ronditrack_mobile.staging
adb shell am force-stop za.co.damiansalley.ronditrack_mobile
```

Sign in and check the requested screen and back chain. For a warm test, leave the
app signed in and issue the link again. Use IDs from the API when testing live
data. In the widget fixtures, Family uses stokvel `2` and cycle `201`.
Requesting cycle `201` under stokvel `1` returns the same not-found message as
a missing cycle. New Member sees that same response for inaccessible cycles.

adb checks intent resolution and navigation, not domain ownership or verified
web-link handling. With an owned HTTPS domain, add an `android:autoVerify` intent
filter and host `/.well-known/assetlinks.json` with each flavour's application ID
and signing-certificate SHA-256 fingerprints. Then verify real taps from a browser
or messaging app. Custom schemes do not provide that verification.

## Theme tokens and measured contrast

Material 3 uses seed `#186B52`, with separate light/dark schemes following the
system. `StatusColors` extends the theme for every contribution/cycle status,
including unknown values, and arrears. Status words remain visible without colour.
Presentation widgets contain no literal colours.

The checker is `test/layout_theme_test.dart`: Flutter `Color.computeLuminance()`
and WCAG's `(lighter + 0.05) / (darker + 0.05)` formula. It asserts every pair
below. Text exceeds 4.5:1; outlines exceed 3:1. Status text uses surface backgrounds.

| Token | Light FG / BG | Ratio | Dark FG / BG | Ratio |
|---|---|---:|---|---:|
| onSurface | #171D1A / #F5FBF6 | 16.31 | #DEE4DF / #0F1512 | 14.32 |
| onSurfaceVariant | #404944 / #F5FBF6 | 8.88 | #BFC9C2 / #0F1512 | 10.87 |
| primary | #196B52 / #F5FBF6 | 6.13 | #8AD6B7 / #0F1512 | 10.90 |
| onPrimary | #FFFFFF / #196B52 | 6.43 | #003828 / #8AD6B7 | 7.76 |
| outline (control) | #707974 / #F5FBF6 | 4.28 | #89938D / #0F1512 | 5.83 |
| arrears | #9B2424 / #F5FBF6 | 7.49 | #FFB4AB / #0F1512 | 10.88 |
| contribution.pending | #6B4800 / #F5FBF6 | 7.84 | #FFD180 / #0F1512 | 12.92 |
| contribution.paid | #174EA6 / #F5FBF6 | 7.48 | #A8C7FA / #0F1512 | 10.75 |
| contribution.confirmed | #14633E / #F5FBF6 | 6.94 | #8FD9AD / #0F1512 | 11.17 |
| contribution.unknown | #43525F / #F5FBF6 | 7.67 | #CBD5E1 / #0F1512 | 12.45 |
| cycle.active | #14633E / #F5FBF6 | 6.94 | #8FD9AD / #0F1512 | 11.17 |
| cycle.closed | #6B4800 / #F5FBF6 | 7.84 | #FFD180 / #0F1512 | 12.92 |
| cycle.paid | #174EA6 / #F5FBF6 | 7.48 | #A8C7FA / #0F1512 | 10.75 |
| cycle.unknown | #43525F / #F5FBF6 | 7.67 | #CBD5E1 / #0F1512 | 12.45 |

## Responsive layouts

Window breakpoints live once in `lib/core/breakpoints.dart`:

| Width (dp) | Navigation | Stokvels |
|---|---|---|
| Below 600 | Bottom NavigationBar | List or detail |
| 600–839 | Labelled NavigationRail | List or detail |
| 840 and wider | Labelled NavigationRail | List beside addressed detail |

Resizing changes panes without navigating. Pages scroll, text wraps, actions
wrap, amounts sit below member names, and the detail toolbar grows with text.
Layout tests cover 360×640 at 200% text and tablet rotation/back navigation.

## Assignment 10.2 verification and submission

```bash
flutter pub get --enforce-lockfile
dart run build_runner build
dart format --output=none --set-exit-if-changed .
dart analyze --fatal-infos
flutter test
```

Regenerate twice and compare generated-file hashes to verify reproducibility.
The existing PR workflow also checks regeneration against committed sources.
Router versions are pinned as required: `go_router 18.1.1` and
`go_router_builder 4.5.2`. No hosted CI result is claimed before the owner submits.

See [current check results](docs/completion-report.md) and
[evidence/capture instructions](docs/evidence/assignment-10.2/README.md).
Required PR evidence: Home and stokvel screenshots in light and dark; 360 dp at
200% text; tablet list/detail; cold cycle link recording including back; signed-out
invite through sign-in recording; non-member not-found screenshot.

## Assignment 10.1 foundation (historical)

Flutter foundations and Riverpod state management using fake repositories.

The mobile application does not call the API yet. API integration is planned for Week 11.

Choose a persona on Sign in. Open a Home card or Stokvel list entry, or use the
detail picker to switch stokvels.

## Backend contract

Backend repository: https://github.com/Damian-Salley/RondiTrack

Original backend commit:
`7c2651bc7689206c90a9d89c12ad871254c947d4`

Assignment 10.1 backend commit:
`1e23b75266a0e56f1e3658c84fc54fb8af29c9fd`

Backend pull request:
https://github.com/Damian-Salley/RondiTrack/pull/6

The original backend OpenAPI contract was missing several fields and endpoints required by the mobile application.

The backend was updated to provide:

- Exact integer-cent monetary values.
- Contribution-cycle status and due dates.
- Updated stokvel and contribution-cycle responses.
- Contribution confirmation with role-based authorization.
- A third development seed persona.
- Updated OpenAPI documentation.
- Automated regression tests.

These backend changes were committed and pushed separately.

The backend pull request's GitHub CI checks passed.

The mobile project's [OpenAPI contract](contract/openapi.json) was exported from the updated ASP.NET application during:

`Assignment101Tests.OpenApi_ExportsCurrentCentsAndDetailContract`

The exported contract's SHA-256 hash was verified locally.

See [contract provenance](contract/provenance.json) for the source commit, pull request, and verification information.

### API status values

The API uses these exact strings:

**CycleStatus**
- `Active`
- `Closed`
- `Paid`

**ContributionStatus**
- `Pending`
- `Paid`
- `Confirmed`

**StokvelRole**
- `Member`
- `Treasurer`
- `Chairperson`

The UI may display friendlier labels such as Open or Paid out, but these do not change the API values.

Unknown or differently capitalized status strings map to `unknown`.

Unknown values safely suppress status-dependent actions.

### Membership roles

`GET /api/v1/me/home` returns a list containing a `stokvelId` and `role` for each membership.

The mobile application represents these using:

`Membership(stokvelId, role)`

Neither `/api/v1/me` nor the JWT supplies stokvel-specific roles.

The detail screen receives membership information from Home together with the relevant stokvel, cycle, and contribution information.

`StokvelDetail` is a client-side aggregate, not a separate API endpoint.

There is no `User.role` property.

### Monetary values

The mobile application uses exact integer-cent values rather than floating-point monetary calculations.

Relevant API fields include:

- `contributionAmountCents`
- `targetAmountCents`
- `requiredContributionCents`
- `amountCents`
- `arrearsCents`
- `totalCollectedCents`

Home values such as `paidThisCycle` and `stillOwes` are supplied by the backend.

The application displays these values without recalculating the backend's totals.

`totalCollectedCents` is serialized as an integer string.

The backend retains legacy decimal fields for existing clients.

### Nullable values

The following Home fields may be null:

- `currentCycle`
- `cycleStatus`
- `nextPayoutDate`

`currentCycle` refers to the cycle number.

The development seed has no future payout recorded, so its Home payout date is null.

### Dates

`dueDateUtc` and `nextPayoutDate` represent UTC instants rather than date-only values.

Domain models use `DateTime`.

The detail screen explicitly identifies UTC dates.

Local calendar presentation is planned for Week 11.

## Development personas

Three personas are available for demonstrating different application states.

| Persona | Backend seed email | Demonstration data |
|---|---|---|
| Lerato | assignment71-demo@ronditrack.example | Treasurer of Community Savings and Member of Mabena Family |
| Sipho | assignment71-contributor@ronditrack.example | Member of both stokvels, with contribution and arrears examples |
| New Member | assignment101-new@ronditrack.example | No memberships; Home displays its empty state |

### Lerato

Community Savings:
- Paid R250.
- No arrears.
- Treasurer permissions.

Mabena Family:
- Pending R100 contribution.
- Paid zero.
- Owes R100.
- Member permissions.

### Sipho

Community Savings:
- Confirmed R0.10 contribution.
- Owes R249.90.
- R250 arrears from a closed cycle.

Mabena Family:
- No contribution.
- Owes R100.

### Current cycles

Community Savings:
- Required contribution: R250 per member.
- Target: R500.

Mabena Family:
- Required contribution: R100 per member.
- Target: R200.

Both current cycles end at:

`2026-11-30T22:00:00Z`

The backend also seeds Closed and Paid historical Community Savings cycles.

Fake repositories use stable local identifiers. Backend identifiers are allocated separately.

The fake data represents the same demonstration scenarios, although date-dependent backend figures may change when monthly closing runs.

## Action permissions

Actions depend on:

- Membership role.
- Cycle status.
- The user's own contribution status.
- Whether any Paid contributions are available for confirmation.

Unknown values suppress actions safely.

| Role / cycle / contribution | Available actions |
|---|---|
| Unknown role or status | None |
| Closed or Paid cycle | None |
| Member / Active / no contribution | Pay |
| Member / Active / existing contribution | Upload own proof |
| Treasurer / Active / no contribution | Pay, confirm contributions, close cycle, record payout |
| Treasurer / Active / existing contribution | Upload own proof, confirm contributions, close cycle, record payout |
| Chairperson / Active / no contribution | Pay, record payout |
| Chairperson / Active / existing contribution | Upload own proof, record payout |

Contribution confirmation is available only when an eligible Paid contribution exists.

The application calculates available actions in the domain layer rather than implementing permission decisions directly in widgets.

The treasurer's own contribution status is not used as another member's payment status.

An existing Pending contribution represents an existing record, not an invented unpaid state.

The API rejects duplicate contributions.

The existing payout service accepts Active cycles and rejects Closed or Paid cycles.

Newer closing and confirmation workflows require the Treasurer role.

Chairperson permissions are not automatically treated as equivalent to Treasurer permissions.

**All mobile actions remain placeholders until Week 11.**

The backend will independently enforce authorization when real API integration is implemented.

## Running the application

### Requirements

- Flutter 3.47.7
- Dart 3.13.5
- Android Studio
- Android SDK and emulator

Check the Flutter installation:

```bash
flutter doctor
```

The development machine's Flutter SDK may report an unknown-channel warning (`user-branch`), although the installed Flutter version is correct.

Android builds have been verified on Windows.

iOS scaffolding is included, but iOS builds require macOS and have not been verified.

### Install dependencies

```bash
flutter pub get --enforce-lockfile
```

### Generate source files

```bash
dart run build_runner build
```

### Run development

```bash
flutter run --flavor dev --dart-define-from-file=config/dev.json
```

### Run staging

```bash
flutter run --flavor staging --dart-define-from-file=config/staging.json
```

### Run production

```bash
flutter run --flavor prod --dart-define-from-file=config/prod.json
```

## Environment configuration

Each configuration file contains only:

- `FLAVOR`
- `API_BASE_URL`
- `REFRESH_COOKIE_NAME`

### Development

File: `config/dev.json`

```json
{
  "FLAVOR": "dev",
  "REFRESH_COOKIE_NAME": "refreshToken",
  "API_BASE_URL": "http://10.0.2.2:5274/api/v1"
}
```

`10.0.2.2` allows the Android emulator to access the API running on the development computer.

The backend's corresponding local address is:

`http://localhost:5274/api/v1`

### Staging

File: `config/staging.json`

```json
{
  "FLAVOR": "staging",
  "REFRESH_COOKIE_NAME": "refreshToken",
  "API_BASE_URL": "https://staging.ronditrack.example/api/v1"
}
```

### Production

File: `config/prod.json`

```json
{
  "FLAVOR": "prod",
  "REFRESH_COOKIE_NAME": "refreshToken",
  "API_BASE_URL": "https://ronditrack.example/api/v1"
}
```

The staging and production addresses are placeholders.

They must be replaced with deployed API addresses before real integration.

No credentials, authentication tokens, or secrets are stored in these configuration files.

### Flavor validation

The application validates configuration before `runApp`.

It compares the configured flavor with Flutter's native `appFlavor`.

Android Gradle configuration also rejects missing or mismatched flavor configuration.

| Flavor | Launcher name | Application ID |
|---|---|---|
| dev | RondiTrack Dev | za.co.damiansalley.ronditrack_mobile.dev |
| staging | RondiTrack Staging | za.co.damiansalley.ronditrack_mobile.staging |
| prod | RondiTrack | za.co.damiansalley.ronditrack_mobile |

Launcher names use flavor-specific Android string resources.

Restart the application after changing configuration, Gradle files, or Android manifests.

## Backend development setup

The mobile application does not require the backend to run during Assignment 10.1.

For future integration, follow the backend repository's README.

The backend requires:

- .NET 10.
- PostgreSQL.
- A configured database connection string.
- A JWT signing key.
- Database migrations.

Development seed data requires the appropriate seed configuration and demo-user password.

Store credentials using .NET user-secrets.

Never commit credentials or signing keys.

## Architecture

The application separates responsibilities into the following areas:

### `lib/app`

Application startup, configuration, and theme.

### `lib/core`

Shared functionality, including:

- Exact monetary values.
- Sealed view states.
- Shared state-message widgets.

### `lib/features/home`

Home domain contracts, fake data, providers, and presentation.

### `lib/features/stokvels`

Stokvel detail models, fake data, providers, permissions, and presentation.

### `lib/features/session`

Development persona selection and session state.

Repository implementations are selected through feature-specific provider files.

Presentation widgets depend on domain types and providers rather than concrete repository implementations.

Fake repository constructors can be replaced with real implementations during Week 11.

## Riverpod state management

Home uses a generated `AsyncNotifier`.

Stokvel detail uses an auto-disposed provider family keyed by stokvel ID.

Changing the selected stokvel changes the watched provider key immediately.

The application converts asynchronous results into sealed view states:

- Loading.
- Empty.
- Data.
- Failure.

Screens use exhaustive switches to render these states.

Refreshing Home retains existing cards while showing progress.

Changing the selected session hides previous session data immediately.

Missing and inaccessible stokvels both display:

`Stokvel not found.`

Failures provide a Retry action.

Tests disable Riverpod's automatic retry so failure states remain observable.

## Generated code

Commit generated Dart source files, including:

- `.g.dart`
- `.freezed.dart`

Also commit:

- `pubspec.lock`

This allows a fresh checkout to analyze and build consistently.

The CI workflow:

1. Resolves locked dependencies.
2. Checks formatting.
3. Regenerates source files.
4. Verifies generated files have not changed.
5. Runs strict Dart analysis.
6. Runs Flutter tests.

Generated source files are excluded from lint analysis.

Maintained application code is analyzed strictly.

`public_member_api_docs` is disabled because this is a private application rather than a published Dart API.

No Riverpod lint is disabled.

### Dependency versions

The project pins its direct dependencies, including:

- flutter_riverpod 3.4.3
- riverpod_annotation 4.0.7
- riverpod_generator 4.0.9
- riverpod_lint 3.1.9
- freezed 4.0.3
- freezed_annotation 3.1.0
- very_good_analysis 11.0.0
- build_runner 2.16.2

The assignment specifically requires `build_runner 2.16.2`.

The lockfile preserves compatible dependency versions.

Avoid unnecessary dependency upgrades immediately before submission.

## Riverpod lint evidence

A temporary public property was introduced into the Session notifier to demonstrate the Riverpod lint:

`avoid_public_notifier_properties`

The temporary change was analyzed and removed.

The failing local output is recorded in:

[Riverpod lint evidence](docs/evidence/riverpod-lint-analysis.txt)

On this toolchain, `flutter analyze` alone does not execute all analyzer plugins.

The CI workflow uses:

```bash
dart analyze --fatal-infos
```

This ensures Riverpod lint findings fail analysis.

The local lint experiment is not evidence of a deliberately failing GitHub CI run.

If the assignment requires red-to-green GitHub CI evidence, that evidence must be captured separately.

## Exact monetary calculations

The application represents money using a `Cents` extension type over `int`.

Formatting uses integer division and remainders rather than floating-point arithmetic.

Currency formatting uses non-breaking spaces (`U+00A0`).

Examples:

- `R 0,10`
- `R 150,50`
- `R 1 500,00`
- `R 1 000 000,00`
- `-R 150,50`

### Rand input parsing

The parser supports:

- An optional leading uppercase `R`.
- Whitespace around the input.
- Correctly grouped ordinary or non-breaking spaces.
- Zero, one, or two decimal digits.
- A comma or full stop as the decimal separator.

It rejects:

- Mixed decimal separators.
- Trailing decimal separators.
- More than two decimal digits.
- Malformed grouping.
- Letters.
- Empty input.
- Negative input.
- Values exceeding signed 64-bit cents.

A full stop is treated as a decimal separator, not a thousands separator.

The parser uses `BigInt` arithmetic to detect overflow before converting to cents.

It never silently rounds monetary values.

## Handling new API statuses

The application uses exhaustive enum switches for status labels and action permissions.

A temporary `paused` cycle status was introduced during testing.

Strict analysis correctly reported missing switch cases.

The temporary status was then removed.

The evidence is available in:

[Added-status analysis](docs/evidence/added-status-analysis.txt)

An older application receiving an unfamiliar API status maps it to `unknown`, displays a safe label, and hides dependent actions.

A developer adding a new known enum case must update the relevant exhaustive switches.

This prevents new statuses from silently inheriting inappropriate behavior.

## Provider lifetimes

| Provider | Lifetime | Purpose |
|---|---|---|
| sessionProvider | keepAlive | Retains the selected development persona |
| homeRepositoryProvider | autoDispose | Provides the Home repository |
| homeProvider | autoDispose | Loads and stores Home summaries |
| stokvelRepositoryProvider | autoDispose | Provides the detail repository |
| detailProvider(id) | autoDispose | Loads detail for a specific stokvel ID |

### Session

The selected demo persona survives normal navigation.

A real sign-out flow must reset session state and clear user-specific cached data.

### Home

Home data is released when no longer needed.

Returning to Home may trigger a new fetch.

### Detail

Each stokvel ID has its own provider instance.

Two listeners for the same ID share one fetch.

The provider is disposed after its final listener closes.

This avoids retaining unnecessary contribution data.

### Provider tests

Tests verify:

- Separate stokvel IDs maintain separate state.
- Multiple listeners share a fetch.
- Disposal occurs after the final listener closes.
- Switching to a slower-loading stokvel immediately shows the new loading state.
- Previous stokvel contributions are not displayed during the switch.

Disposal logs contain only stokvel identifiers, not personal or monetary information.

### Sign-out behavior

The API-backed repositories depend on the current auth state. Sign-out removes
the signed-in shell, releases its auto-disposed providers, and rebuilds session
dependencies when the next account signs in.

## Validation

### Formatting

```bash
dart format --output=none --set-exit-if-changed lib test
```

### Generated source

```bash
dart run build_runner build
```

### Strict analysis

```bash
dart analyze --fatal-infos
```

### Flutter analysis

```bash
flutter analyze
```

### Automated tests

```bash
flutter test
```

### Development Android build

```bash
flutter build apk --debug --flavor dev --dart-define-from-file=config/dev.json
```

### Staging Android build

```bash
flutter build apk --debug --flavor staging --dart-define-from-file=config/staging.json
```

### Production Android build

```bash
flutter build apk --debug --flavor prod --dart-define-from-file=config/prod.json
```

**Important:** An explicit `--flavor` is required.

Running a development build without `--flavor dev` causes the Android configuration validation to reject the build.

## Verification results

### Backend

- 108 automated backend tests passed.
- OpenAPI JSON validated.
- OpenAPI contract hash verified.
- Backend changes committed and pushed.
- Backend pull request created.
- Backend GitHub CI checks passed.

### Flutter

- `flutter analyze`: No issues found.
- `flutter test`: 63 tests passed.
- Development Android debug APK: Built successfully.
- Staging and production debug APK builds: Previously verified locally.
- Exact monetary formatting and parsing tests included.
- Riverpod provider lifecycle tests included.
- Widget state and permission tests included.

The development APK was generated at:

`build/app/outputs/flutter-apk/app-dev-debug.apk`

These results establish local automated verification and Android debug build success.

They do not establish production deployment, store signing, or iOS build verification.

## Evidence and completion report

Additional evidence is stored in:

`docs/evidence/`

See:

[Assignment 10.1 Completion Report](docs/completion-report.md)

The completion report records requirement coverage, testing evidence, and remaining submission items.

## Submission status

### Backend

- Implementation complete.
- Tests passed.
- Changes committed and pushed.
- Pull request created.
- GitHub CI checks green.

### Mobile

- Implementation prepared.
- Automated tests passed.
- Static analysis passed.
- Development Android build passed.
- Backend contract provenance updated.
- Final documentation review in progress.
- Mobile commit and pull request pending.

The mobile pull request and its CI results must be verified before claiming the complete mobile submission is finished.

No merge into `main` is claimed.

## Assignment 10.3 contract notes (read before adding payout types)

API baseline: `9958be9` (merged Assignment 10.1 backend); the necessary local
fix is on `feature/assignment-10.3-backend`. Its verified commit (`729079e`) and exported
OpenAPI hash are recorded in `contract/provenance.json`.
Sources: backend README, `Services/RondiTrackService.cs`,
`Controllers/StokvelsController.cs`, and the application's `/openapi/v1.json`.
The checked-in backend `openapi.json` is an older snapshot; the mobile contract
copy is exported by an integration test from the actual application.

| Question | Contract answer |
|---|---|
| Payout order endpoint and shape | GET `/api/v1/stokvels/{stokvelId}/cycles/{cycleId}/payouts`: array of `userId`, `memberName`, one-based `position`, `amountCents` (Int64 whole cents), nullable `paidAtUtc` (UTC instant), `status`. No scheduled date is promised. |
| Exact status spellings | `Paid`, `Next`, `Waiting`; future values map to `unknown`. |
| Who is next? | The API marks `Next` using the same recipient helper as payout processing. The app never sorts, sums, counts paid members or chooses a recipient. Closed/paid cycles have no next recipient. |
| Non-member response | 404, also for missing/mismatched cycles; fake throws the same not-found outcome. Anonymous API callers receive 401. |
| Who records? | Existing POST `.../payout`: Treasurer or Chairperson from this stokvel's membership; Member receives 403, non-member 404. The existing exhaustive `allowedActions` rule remains authoritative for UI actions. |

The baseline API only had POST payout processing, so the read endpoint is a
required backend fix. No schema migration, package, or new payout business rule
is needed. Backend tests cover access, order, next, paid amount/date and empty.
The owner will publish/link separate backend and mobile PRs after local review.

### Payout status tokens

All pairs reuse measured contribution tokens in `StatusColors.payout`, on the
same theme surface. `test/payout_theme_test.dart` measures every status in both
modes; words accompany colours.

| Token / reused meaning | Light FG / BG | Ratio | Dark FG / BG | Ratio |
|---|---|---:|---|---:|
| payout.paid / contribution.paid | #174EA6 / #F5FBF6 | 7.48 | #A8C7FA / #0F1512 | 10.75 |
| payout.next / contribution.confirmed (positive emphasis) | #14633E / #F5FBF6 | 6.94 | #8FD9AD / #0F1512 | 11.17 |
| payout.waiting / contribution.pending | #6B4800 / #F5FBF6 | 7.84 | #FFD180 / #0F1512 | 12.92 |
| payout.unknown / contribution.unknown | #43525F / #F5FBF6 | 7.67 | #CBD5E1 / #0F1512 | 12.45 |



## Assignment 10.3 personas

These are display aliases for the existing 10.1 seeds, with stable IDs and emails:
Lerato = Demo Member (`assignment71-demo@ronditrack.example`), Sipho = Sample
Contributor (`assignment71-contributor@ronditrack.example`), New Member =
`assignment101-new@ronditrack.example`. Mabena Family is the mobile display name
for the backend's Family Savings fixture. These aliases change no API roles.

| Persona | Home | Community Savings (1 / cycle 101) | Mabena Family (2 / cycle 201) | Payouts |
|---|---|---|---|---|
| Lerato | Two stokvels; Paid R250 / Owed R0 in Community, Paid R0 / Owed R100 in Family | Treasurer: confirm paid contributions, close, record payout; own upload proof | Member: own upload proof; no management actions | Community: server order Lerato Next, Sipho Waiting, R500 each, Record payout; Family: no payout order yet |
| Sipho | Two stokvels; Paid R0.10 / Owed R249.90 in Community, Paid R0 / Owed R100 in Family | Member: own upload proof; no management actions | Member: Pay; no management actions | Same Community order without Record payout; Family: no payout order yet |
| New Member | No stokvels; ask an organiser for an invite | Stokvel not found | Stokvel not found | Cycle not found for either cycle; no retry spinner |

The dev sign-in picker fills the email field. Sign out from Profile to choose
another account. Staging and production tests verify that the picker is absent.

The fake repositories still watch `sessionProvider` for fixture changes. The
first-frame tests in `test/persona_test.dart` cover stokvel details and payouts
when the fixture changes. The same `appRetry` function is used in
main and whole-app tests: requests do not automatically retry; recoverable
failures expose a Retry button, while not-found exposes only its message.

`test/routes_table_test.dart` parses the Routes table and opens every listed
address. Existing navigation, access, activity and large-text tests still run.
Payout records/actions remain fake/read-only Week 10 demonstrations; the record
button retains the existing Week 11 placeholder, with no financial write.

## Architecture rules

`test/architecture_test.dart` scans every Dart file under `lib/features`,
including generated files. It rejects literal colours and colour constructors
or palettes (`Color`, `Colors`, Material/Cupertino palettes, HSL/HSV, hex values).
Screens (by filename or Screen class) cannot import/export a `data/` folder,
Dio or Drift. Composition roots may import data; screens consume their domain
interfaces through providers. There are **no exceptions**, so there are no
exception expiry dates. Any future exception must state its reason and ending
week in the test, with an expiry assertion. The existing CI `flutter test` step
runs these checks alongside every other test. Guard fixtures prove the detector
recognises each prohibited dependency and permits theme-token use.


## Assignment 10.3 verification and review

The compulsory requirements, local commit sequence, actual results and owner
submission steps are in [the completion report](docs/assignment-10.3-completion.md).
Use [the prepared PR description](docs/assignment-10.3-pr-description.md) and
[real device/test evidence](docs/evidence/assignment-10.3/README.md) after review.
All 134 mobile tests and 109 backend tests passed. Formatting, strict analysis,
locked resolution, two stable generation runs, dev/staging/prod debug APKs and
a prod release APK passed. Hosted CI/PR links await the owner's publication;
no push, merge or PR was made during this task.

Family's empty order is a deliberate empty-response fixture for the required
empty screen, not a claim that the backend's currently seeded Family rotation
is empty. Both fakes use the API response shape, and mobile computes no order.

## Assignment 11.1 contract notes

Source review used backend commit `b88302cd58ed1bb84aeb54b899985f08608d10bb`.
The client snapshot comes from backend fix commit
`b2652fc8bec762024fec93e76fe49570078e8e04` on
`feature/assignment-11.1-backend`. The backend integration test exported the
live `/openapi/v1.json`, and both repositories use that same file.

| Question | Verified in backend source |
| --- | --- |
| How does pagination end? | The repositories return a null `nextPageToken` when there is no next page. Contribution tokens include filter and sort criteria. Changing those criteria with an existing token returns 400. |
| How are stale writes handled? | Close preview returns an opaque `version`. Close sends that string back in its JSON body with an `Idempotency-Key` header. A stale version returns 409. |
| What are the exact statuses? | Cycle: `Active`, `Closed`, `Paid`. Contribution: `Pending`, `Paid`, `Confirmed`. Membership: `Member`, `Treasurer`, `Chairperson`. Payout order: `Paid`, `Next`, `Waiting`. |
| What is the authentication lifetime? | The cookie is `refreshToken`. Access JWTs expire in 15 minutes. A used or revoked refresh token triggers family revocation immediately. |
| Is every correlation ID documented and returned? | Problem-details writers attach `correlationId` as an extension. The checked-in schema does not declare the property. Activity also has explicit string 400 responses, so a correlation ID cannot be assumed from every body. |
| What do members and non-members receive? | Membership checks conceal inaccessible stokvels and cycles with 404. A member attempting a treasurer-only contribution confirmation or cycle close receives 403. |
| Which endpoints are rate limited? | Login uses the per-IP Login policy. Invite creation, lookup and join, cycle close, both contribution recording routes and payout recording use Financial. Rejections return 429 with integer seconds in `Retry-After`. |

The development seed names its dual-role user **Demo Member**, a Treasurer of
Community Savings and a Member of Family Savings. The assignment calls this
persona **Lerato**. The other two seeded accounts are Sample Contributor and
New Member.

### Running against the API

In the backend repository, use a fresh disposable PostgreSQL database and
apply migrations with `dotnet ef database update`. Configure
`ConnectionStrings:RondiTrack`, `Jwt:Key`, `SeedDemoData=true` and
`DemoUserPassword` in your local environment or .NET user secrets. Use a
development password of at least 12 characters. Run
`dotnet run --launch-profile http` to serve the API at port 5274.

On an Android emulator, start the mobile app with
`flutter run --flavor dev --dart-define-from-file=config/dev.json`.
The emulator uses `10.0.2.2` to reach the host. Type the development password
on the sign-in screen.

For live tests on the host, set `RONDI_LIVE_URL` to
`http://127.0.0.1:5274` and pass the development password through the
`RONDI_LIVE_PASSWORD` process environment. Run
`flutter test --tags live test/real_api_live_test.dart --reporter expanded`.
The suite uses five local sign-ins, the default allowance per IP per minute.
Wait for the window to reset if the emulator used a sign-in first. The tests
skip when either variable is absent. The recorded backend commit enforces
refresh-token reuse detection immediately and requires no grace-window setting.

### The API client

`contract/openapi/v1.json` is an exact copy of backend `openapi/v1.json`.
Delete the generated directory before regenerating so obsolete files disappear.

```powershell
Remove-Item -LiteralPath lib/core/data/generated -Recurse
dart run swagger_parser
dart format lib/core/data/generated
dart run build_runner build
```

CI regenerates the client and checks for both changed and untracked files. A
separate job compares the contract with the backend revision recorded below.
Use the `api_ref` workflow input to compare another backend branch or commit.
[Assignment 11.1 backend PR #8](https://github.com/Damian-Salley/RondiTrack/pull/8)

### Failures

| API response | Failure | Screen message |
| --- | --- | --- |
| 400 | Validation | API detail, with field errors retained |
| 401 | Unauthorised | Sign in to continue |
| 403 | Forbidden | Your role does not allow this action |
| 404 | Not found | Not found |
| 409 or 412 | Conflict | API detail or a prompt to reload |
| 410, 422 or another client rule | Rule | API detail or action unavailable |
| 429 | Rate limited | Wait time in seconds from `Retry-After` |
| 5xx or unreadable response | Server | Generic apology and a copyable reference when present |
| Connection error or timeout | Offline | Offline or unreachable message and Try again |

### Decisions

The client is generated with the assignment's pinned tools so a backend field
change is reflected in compile-time mapper references. API reads return a Dart
record carrying the value or failure. The Week 10 repository methods unwrap
that record, which lets existing fakes work while Riverpod receives typed
errors as `AsyncError`.
The dev build offers a persona email picker.

The transport allows 5 seconds to connect before reporting an unreachable
host and 5 seconds to send the small JSON requests used here. It allows
25 seconds to receive the response, including the API's three PostgreSQL retries.
In an isolated test, authenticated Home reported 500 after 10.41 seconds
when PostgreSQL was stopped. The app offers manual retry for connection
failures and timeouts. It does not retry HTTP failures or writes.

## Contract notes

### Offline, forms and lists

Verified the initial contract against backend `7c7350e811c5c074b19cf14cf1b340c60efac987`. This app consumes the exported contract from `616730a7e4d09d4839c32b8317b6a39748a35ad8`, which adds persistent replay, ordinary stokvel versions, and combined history filters. [Backend PR #9](https://github.com/Damian-Salley/RondiTrack/pull/9)

1. Both contribution POST routes take `Idempotency-Key`. The cycle route returns HTTP 201 with the original contribution on a same-key, same-body replay and sets `Idempotency-Replayed: true`. The legacy route returns HTTP 200. Changed payloads return 409 with title “Idempotency conflict”. The contribution and its replay receipt commit together in PostgreSQL. Keys remain valid for 24 hours (M = 1 day), with hourly housekeeping. The contribution's database key also prevents a second contribution for the same member and cycle. The close-cycle POST takes an idempotency key and has a separate persisted receipt.
2. The current cycle payment route returns 409 with title “Duplicate contribution” when a member has already contributed. A closed or paid-out cycle returns 422 with title “Business rule violated” and generic detail. Access outside the caller's membership returns 404. A payer with insufficient permission to act for another member receives 403. The financial limiter defaults to 20 operations per minute and replies with 429 and `Retry-After` in seconds.
3. Stokvel GET returns a version and PUT accepts it in `version`. A stale edit returns 409 with detail “This stokvel changed. Review the latest details and try again.” The form preserves the draft and shows the current server values before another save. The existing cycle close workflow checks its preview version and returns 409 with “Payments or membership changed. Review the new preview and confirm again.” Ordinary cycle edits do not use the stokvel version.
4. Contribution history accepts `pageSize`, opaque `pageToken`, `cycleId`, `status` (`Paid`, `Confirmed`, or `Pending`), `userId`, and UTC `from` and `to` instants. Default size is 20 and the cap is 100. A null `nextPageToken` ends pagination. The interval is inclusive at the start and exclusive at the end. Unfiltered history shows timestamped payments. The explicit `Pending` filter also finds undated server rows when the date range is clear.
5. Payment sends integer `userId` and `amountInCents` with stokvel and cycle IDs in the path. The server sets the payment time. Create sends `id`, `name`, and `contributionAmount` as an exact JSON decimal in rands. Both endpoints use those camel-case field names in validation `errors`. Create currently requires a caller-supplied positive ID and accepts no date field. Cycle writes use UTC date-time fields.
6. Proof endpoints return payment files and proof details. Those responses and member contact details are excluded from the offline cache. Home, stokvel detail, and cycle DTOs carry the summary fields used by the offline views. Credentials remain in secure session storage.

### Auth

Backend source reviewed at `7c7350e811c5c074b19cf14cf1b340c60efac987`.
The local API at port 5274 returned the header and status observations below.

1. Under `/api/v1/auth`, register accepts JSON `firstName`, `lastName`,
   `email`, `phoneNumber`, and `password`. It returns 201 with ID, names
   and email. The user signs in next. Login accepts JSON `email` and
   `password`, and returns 200 with `accessToken`, `tokenType` and
   `expiresIn` plus a refresh cookie. Refresh accepts that cookie without
   a body and returns the same response shape with replacement credentials.
   Logout accepts the cookie without a body and returns 204. An empty
   registration request returned 400 with an `errors` map keyed by all
   five fields. The controller returns 409 for an existing email and 400
   with password detail for a password shorter than 12 characters.
2. Login and refresh set
   `Set-Cookie: refreshToken=<redacted>; expires=<UTC date seven days after issuance>; path=/api/v1/auth; secure; samesite=strict; httponly`.
   The name, path and attributes are also visible on the local logout
   response. Access lifetime is hard-coded at 15 minutes in
   `AuthController`, with `expiresIn: 900` and a JWT `exp`.
3. Refresh consumes the old token and creates a replacement in the same
   family. A subsequent reuse of a spent or revoked token returns 401 and
   revokes that family, including its replacement. The rotation race
   loser also returns 401. This commit has no grace window setting, so
   strict behaviour is already active for live tests. A refresh without
   a cookie returned 401 locally.
4. The signed JWT contains `sub` (user ID), `jti`, the platform role
   under the .NET role claim URI, `iss`, `aud`, and `exp`. Stokvel roles
   come from membership data, as in 11.1.
5. Logout returns 204 with a cookie deletion header for valid, spent, and
   absent cookies. Valid and spent known cookies revoke the entire family.
   The no-cookie request returned 204 and an empty cookie expiring at the
   Unix epoch on the auth path.
6. Login uses a fixed per-IP window, five requests per 60 seconds by
   default, including successful attempts. Register has no rate limiter
   in this commit. Rejections send 429 and integer seconds in `Retry-After`.
7. Authenticated `POST /api/v1/invites/{code}/join` returns 200 with
   `stokvelId` for new and existing members of a valid invite. An unknown
   code returns 404 and an expired code returns 410. The authenticated
   preview route also returns `alreadyMember` and `stokvelId`. A local
   join without a bearer token returned 401.

### The session

The access JWT and its expiry live in memory. The refresh cookie value lives
in a flavour-specific entry in `flutter_secure_storage`. Dio sends it only
to refresh and logout. One in-flight refresh serves concurrent requests. The
interceptor refreshes near expiry and retries a rejected request once. A 401
for a replaced access token uses the current access token for that retry.

A refresh 401 clears the session. Transient failures keep it, and the restore
screen offers **Try again** and **Sign out** when startup refresh fails.
Profile sign-out clears the in-memory credentials immediately. The sign-in
screen appears after the secure entry has been deleted. Server logout runs in
the background with a two-second timeout. A response from an earlier session
cannot repopulate credentials or update a data request.

### Decisions

- Auth uses Dio directly so the app can read `Set-Cookie` and
  `Retry-After`. Login and token responses reuse the generated models.
  The invite join response uses the documented `stokvelId` field.
- Each flavour requires `REFRESH_COOKIE_NAME` at startup. Android backup is
  disabled with `android:allowBackup="false"`.
- Refresh starts 30 seconds before the earlier of JWT expiry and the reported
  lifetime. The retry uses a separate Dio client to avoid recursion.
- `flutter_secure_storage` is pinned to 11.2.0. The lockfile pins each
  hosted version. The November 21 audit required holding `jni` at 1.1.2,
  `jni_flutter` at 1.0.4+1, and `material_ui` at 1.10.0. Re-audit before
  removing the overrides. The November 19 JNI release reaches two weeks on
  December 3, the November 18 JNI Flutter release on December 2, and
  the November 16 Material UI release on November 30.

[Assignment 11.2 verification evidence](docs/evidence/assignment-11.2/README.md)

## Offline

Drift keeps one Home snapshot, stokvel detail snapshots keyed by route, and current-cycle summaries. Each feature owns the tables and maps them to domain values before presenting them. Screens watch the database directly through their feature repositories, show the last successful update, and retry failed refreshes on demand. A missing stokvel or cycle evicts its cached detail. A previously signed-in session can reopen its cache while a network error prevents token rotation. The first protected request that reaches the server restores the session.

Each queued payment stores its UUID, target, original amount, creation time, and any rate-limit deadline. Pending payments appear separately from amounts supplied by the server. The mobile outbox expires at **12 hours**, and the API keeps payment keys for **24 hours**. Sign-out confirms discard when the queue has entries, clears Drift, removes the refresh credential from secure storage, and invalidates prior session writes. Proof files, proof metadata, bank details, ID numbers, and member contact details stay out of Drift. SharedPreferences holds the language preference.

## Money and dates

The forms parse rand text with a comma or a full stop and accept thousands grouping with ordinary or non-breaking spaces. Integer arithmetic converts the input to cents and rejects zero, negative values, more than two decimal places, and amounts outside the API limit. Payment sends integer cents. Stokvel create and edit serialize an exact JSON decimal token from those cents for the existing `contributionAmount` field. The API sets payment timestamps and accepts no creation date on a stokvel.

Dates in contribution filters mean South African calendar days. For 1 November 2026, the app sends `from=2026-10-31T22:00:00Z` and `to=2026-11-01T22:00:00Z`. The start is inclusive and the end exclusive. The 00:30 SAST payment is 22:30 UTC on 31 October and belongs to 1 November regardless of the device zone.

## Languages

English and Afrikaans use Flutter gen-l10n, ARB messages, and ICU plurals. Choose a language in Profile or use the phone's locale. **Afrikaans is a draft pending first-language review.** No reviewer or review changes have been recorded yet.

## Decisions

- Generate UUID v4 keys with `Random.secure()` at enqueue time. Every retry uses the stored key. A unique queue target prevents a second pending payment for the same member and cycle.
- Page contribution history by hand. Only one request runs at a time. A filter change discards any stale result and starts at the first page. Pull-to-refresh keeps the old rows while the first page loads.
- `cli_util` and `shared_preferences_android` are pinned because their selected newer versions were under two weeks old. Review both overrides on 4 December 2026. Existing `jni`, `jni_flutter`, and `material_ui` overrides remain from Assignment 11.2.

## Assignment 11.3 verification

The Android screenshots, PostgreSQL replay evidence, live test output, deliberate test failures, and hosted time-zone runs are linked from the evidence index. [Assignment 11.3 evidence](docs/evidence/assignment-11.3/README.md)

The named first-language Afrikaans review and independent TalkBack audio verification remain incomplete. The Android walkthrough verified TalkBack focus and error layout at 200% text size.

## Assignment 12.1

### Test plan

| Rule that protects members | Test |
| --- | --- |
| Concurrent expired requests share one refresh | `session_test.dart`, “three expired requests share one rotation and all succeed” |
| Losing signal keeps the known session and its saved Home | `assignment113_offline_test.dart`, “offline startup keeps the known session until a request can refresh it” |
| Sign-out wipes Home, detail and queued payments and blocks old writes | `assignment113_offline_test.dart`, “Drift watches emit domain data and sign-out clears every table” |
| Failed refresh leaves cached detail available, but a 404 evicts it | `assignment113_offline_test.dart`, “cached detail survives offline, refreshes in Drift, and is evicted on 404” |
| One payment target receives one key and retries reuse it | “one payment intent and its key survive an app restart” and “outbox reuses the key when the first response is lost” |
| Rate limiting preserves the key and delays the next send | “429 preserves key and wait, a refusal removes it, and expiry never sends” |
| A payment at the 12-hour limit never sends | “429 preserves key and wait, a refusal removes it, and expiry never sends” |
| Rand input preserves exact integer cents | `assignment113_widgets_test.dart`, “rand input and exact JSON decimal tokens” |
| A near-midnight payment belongs to its South African day | `south_african_day_test.dart`, “00:30 SAST belongs to November 1 in any device time zone” |

| Cycle contribution POST outcome | Queue behavior to prove |
| --- | --- |
| 201 new or 201 replay with `Idempotency-Replayed: true` | Remove the item, publish paid and refresh the cycle. Replay stores one contribution. |
| 400 invalid fields or missing key | Remove and surface validation |
| 401 authentication unavailable after session handling | Retain for session recovery or sign-out wipe |
| 403 payer lacks permission, 404 resource missing or inaccessible | Remove, surface the reason and stop retrying |
| 409 duplicate contribution or idempotency conflict | Remove, communicate the reason and never resend |
| 422 closed or paid-out cycle | Remove and communicate the business rule |
| 429 | Retain key and payment, wait for Retry-After in seconds (60 seconds if absent), then reuse the key |
| No response, 5xx or unreadable response | Retain for a later flush with the same key |
| Item reaches the 12-hour client limit | Remove and publish expiry without sending, inside the API's 24-hour replay window |

Unit tests cover notifier transitions, failure mapping, session and outbox
behavior with mock repositories, scripted transport and local databases.
Widget tests cover visible states, navigation, accessibility and rebuilds.
Goldens cover card appearance, with deterministic CI images and Windows
real-text comparisons. The fast CI job runs these layers in UTC and
Africa/Johannesburg. The dependent Android job signs in with synthetic
fixtures, records a contribution, waits for it on the cycle and checks that
Drift's outbox is empty. This crosses session, payment and visible
confirmation in one journey. Live API tests run separately against an
isolated backend with synthetic data.

#### Coverage

On Assignment 11.3 commit `6f791a6`, `flutter test --coverage` passed 187 tests and skipped three live tests. LCOV reported 1,759 of 2,338 non-generated lines hit (75.24%). The floor is 74%, allowing 1.24 percentage points for ordinary changes while catching a material drop.
Exclude generated API code, localization, Drift, Riverpod and Freezed output. The verified Windows runs reached 77.56% (1,873 of 2,415). Both hosted Linux runs reached 77.43% (1,870 of 2,415).

#### Limits

Manually walk through Home and payment with TalkBack and 200% text. Use the
isolated live checks for API contract and persistence. Check real-text
rendering separately on other supported platforms. Use profile mode on a
physical low-end Android device for timings. Debug mode is sufficient for
counting rebuilds.

### Privacy

| Channel outside normal API requests | Destination and fields |
| --- | --- |
| Error reports | Sentry error events only when a DSN is provided. The reconstructed event carries an event ID, timestamp, environment, release, distribution, SDK metadata, platform, error level, a fixed message and the optional API trace tag. Sentry receives the transport connection address. The signed-in profile name stays in memory for scrubbing. |
| Session data | Automatic session reporting, performance tracing, native crash handling, and client reports are disabled. Launching the app sends no session envelope. |
| Analytics | The production implementation discards the event and the test implementation records it locally. Contribution-recorded contains only integer stokvelId and memberId. These IDs can identify a member in combination with API records and must be treated as personal information. |
| App logs | Local debug console. The detail provider logs a stokvel ID on disposal. The API interceptor logs method, route template, status, elapsed time and correlation ID. The release has no remote log provider and print breadcrumbs are disabled. |

Report unexpected exceptions and server failures centrally. Validation,
permission refusals, unavailable resources, business conflicts, rate
limits and lack of signal are expected outcomes. The backend includes a
top-level `correlationId` on its ProblemDetails writers and logs that value.
It uses the W3C activity trace ID, falling back to the ASP.NET request trace
identifier. A plain-text response, proxy page or connection failure may
provide no reference.

#### Android minimum SDK

Raise Android's Flutter-provided minimum of API 24 to API 26 for
Sentry 10. This excludes Android 7.0 and 7.1 devices. Member device
distribution is unknown. Run the Android journey with controlled fakes
so it exercises the application without contacting a shared API.


### Running the tests

From the mobile repository root, use the pinned Flutter SDK.

```sh
flutter pub get --enforce-lockfile
dart format --output=none --set-exit-if-changed lib test tool integration_test
dart analyze --fatal-infos
flutter test --exclude-tags live --exclude-tags golden
flutter test test/stokvel_card_golden_test.dart
flutter test --coverage --exclude-tags live
dart run tool/check_coverage.dart
flutter test integration_test --flavor dev --dart-define-from-file=config/dev.json
```

Update an intentionally changed golden with
`flutter test --update-goldens test/stokvel_card_golden_test.dart`. Review
both variants after updating. Windows compares real text. The CI variant
uses block text and runs in the fast job in both time zones.

To capture the final Android cycle, run the same journey through the Flutter
SDK driver. The driver saves `assignment-12.1-contribution.png` in the
repository root.

```sh
flutter drive --debug -d emulator-5554 --flavor dev --dart-define-from-file=config/dev.json --dart-define=CAPTURE_ANDROID_SCREENSHOT=true --driver=integration_test/screenshot_driver.dart --target=integration_test/contribution_test.dart
```

Run `flutter test --tags live` after configuring `RONDI_LIVE_URL` and
`RONDI_LIVE_PASSWORD` for a disposable, seeded Development backend only.
In the backend checkout, set `POSTGRES_PASSWORD`, `JWT_KEY` and
`E2E_PASSWORD` privately to disposable values. On a fresh database, run the migration and bootstrap seed in a one-off container first.

```sh
docker compose -p ronditrack-assignment121 -f compose.yaml -f compose.e2e.yaml run --build --rm api
```

Wait for the API to listen, then stop the one-off container with Ctrl+C.
Start the mobile fixture API on loopback with the demo accounts enabled.

```sh
docker compose -p ronditrack-assignment121 -f compose.yaml -f compose.e2e.yaml -f ../RondiTrack-Mobile/tool/compose.assignment-12.1.yaml up -d --build
```

Set `RONDI_LIVE_URL` to `http://127.0.0.1:8080/api/v1` and
`RONDI_LIVE_PASSWORD` to the disposable `E2E_PASSWORD` value. Run the fresh-seed checks first
because the replay test creates an extra stokvel.

```sh
flutter test --tags live test/real_api_live_test.dart
flutter test --tags live test/assignment113_live_test.dart
```

### Performance

Use `dart run tool/contribution_fixtures.dart seed` and
`dart run tool/contribution_fixtures.dart clean` from
the mobile checkout. The scripts select the database of the dedicated
Compose project, add 300 identifiable historical rows and track their
exact keys in a fixture table. The API has no deletion operation for
those contributions. Cleanup checks the fixture keys and values before
removing them and releases the fixture cycles.

The history regression uses 300 synthetic rows, scrolls to the first
row and refreshes the existing page at 200% text scale. The contribution
rows now use a lazy sliver that is reused while controls and progress
indicators update. Row height follows content and text scale. The comparison used the same 300 synthetic rows and 200% text scale in
the Windows x64 Flutter debug test renderer at 800 by 600 logical pixels.
The VM traces use Flutter's widget-build profiling flag and DevTools'
timeline data. They include new mounts. The regression counts only rows
that were already mounted before the refresh.

| Refresh measurement | Before | After |
| --- | ---: | ---: |
| `ListTile` builds in the VM timeline | 9 | 3 |
| Previously mounted rows rebuilt | 1 | 0 |

### Decisions

Use mocktail to check repository calls in provider tests and to isolate
the session in the interceptor test. Use the existing repository fakes
for whole-app widgets and the Android journey, with a programmable
contribution write fake and real Drift storage in the journey.

The assignment adds no new dependency overrides. The existing
`material_ui`, `jni_flutter` and `jni` overrides reach their review dates
on 30 November, 2 December and 3 December 2026 respectively.
Re-audit `cli_util` and `shared_preferences_android` on 4 December 2026
before removing those overrides.

### Deferred Sentry evidence

The real Sentry event and dashboard screenshot are outstanding. The Sentry
integration and passing privacy tests are included in this submission.
The automated scrubber test verifies that synthetic sensitive fields are
removed and the API correlation ID is retained. A real event and screenshot
will be collected separately when the private Sentry project is available.

[Assignment 12.1 evidence](docs/evidence/assignment-12.1/README.md)
