# RondiTrack Mobile — Assignment 10.2

## Routes

Each address uses a generated typed route. All signed-in people share the same four tabs.

| Address | Screen and tab | Signed out | Not a member | Android back, including cold links |
|---|---|---|---|---|
| `/sign-in` | Fake email sign-in, outside tabs | Stay here | Not applicable | Exit |
| `/home` | Home summary, Home | Sign in, then Home | Empty Home | Exit |
| `/stokvels` | Membership list, Stokvels | Sign in, then list | Empty list | Exit |
| `/stokvels/:id` | Stokvel detail, Stokvels | Sign in, then requested detail | Stokvel not found | Stokvel list |
| `/stokvels/:id/cycles/:cycleId` | Cycle detail, Stokvels | Sign in, then requested cycle | Cycle not found, also for mismatched IDs | Parent stokvel, then list |
| `/activity` | Fake cross-stokvel feed, Activity | Sign in, then Activity | Empty feed | Exit |
| `/profile` | Current persona and sign-out, Profile | Sign in, then Profile | Not applicable | Exit |
| `/join/:code` | Invite preview, outside tabs | Sign in, then same preview | Preview; fake join does not change memberships | Home |


## Authentication gate

The app starts signed out. Enter a seed email on Sign in, or tap a persona to fill
it. `authProvider` holds a persona or null and updates the existing 10.1 session
provider. The old Home persona picker has moved to sign-in; Profile shows the
current persona and signs out. Authentication stays in memory, so a cold start
requires sign-in again.

`authRedirect` is one pure, unit-tested gate. Protected addresses go to sign-in
with an encoded `from`; signing in restores that address. `safeDestination`
accepts only known internal routes without schemes, authorities, queries,
fragments or backslashes. Everything else falls back to Home. Our Android custom
scheme links are reduced to their internal path before remembering them.
Riverpod auth changes notify `GoRouter.refreshListenable`, so the gate runs even
without navigation. Sign-out removes the shell and its stacks and invalidates
the session's repositories.

Invites display the original code after sign-in. Join demonstrates the fake flow,
returns Home and shows confirmation; it does not modify seed memberships or call
an API. Payment and treasurer buttons retain their 10.1 Week 11 placeholders.

## Navigation and Android back

Each typed stateful-shell branch keeps its page and scroll. Tapping the active
tab also preserves its position. Back pops the current branch: cycle → stokvel →
list. At a branch root, back exits; it does not replay tab selections. Cold cycle
links build both parents underneath. Invite back goes Home. After sign-out, back
cannot reopen protected screens.

The picker changes the address. Widgets use generated typed routes, with no
string paths or `Navigator.push`. Missing and inaccessible resources give the
same response: `Stokvel not found.` or `Cycle not found.`. Cycles must belong to
their addressed stokvel. The unchanged domain action rules use each stokvel's
membership, never a global persona role.

## Deep links

Custom schemes with host `app` keep installed flavours separate: `ronditrack-dev`,
`ronditrack-staging`, and `ronditrack`. Flutter's native handler forwards cold and
running-app links to the router. Build/install the matching flavour first.
These commands omit a package to test Android's scheme resolution:

```bash
# Dev
adb shell am start -W -a android.intent.action.VIEW -d "ronditrack-dev://app/stokvels/1"
adb shell am start -W -a android.intent.action.VIEW -d "ronditrack-dev://app/stokvels/1/cycles/101"
adb shell am start -W -a android.intent.action.VIEW -d "ronditrack-dev://app/join/family"
# Staging
adb shell am start -W -a android.intent.action.VIEW -d "ronditrack-staging://app/stokvels/1"
adb shell am start -W -a android.intent.action.VIEW -d "ronditrack-staging://app/stokvels/1/cycles/101"
adb shell am start -W -a android.intent.action.VIEW -d "ronditrack-staging://app/join/family"
# Prod
adb shell am start -W -a android.intent.action.VIEW -d "ronditrack://app/stokvels/1"
adb shell am start -W -a android.intent.action.VIEW -d "ronditrack://app/stokvels/1/cycles/101"
adb shell am start -W -a android.intent.action.VIEW -d "ronditrack://app/join/family"
```

For a **cold** test, force-stop the matching package immediately before each link:

```bash
adb shell am force-stop za.co.damiansalley.ronditrack_mobile.dev
adb shell am force-stop za.co.damiansalley.ronditrack_mobile.staging
adb shell am force-stop za.co.damiansalley.ronditrack_mobile
```

Sign in and check the requested screen and back chain. For a warm test, leave the
app signed in and issue the link again. Family uses stokvel `2` and cycle `201`;
cycle `201` under stokvel `1` must show not found. New Member must get the same
not-found response as stokvel `999`.

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
| Demo Member | assignment71-demo@ronditrack.example | Treasurer of Community Savings and Member of Family Savings |
| Sample Contributor | assignment71-contributor@ronditrack.example | Member of both stokvels, with contribution and arrears examples |
| New Member | assignment101-new@ronditrack.example | No memberships; Home displays its empty state |

### Demo Member

Community Savings:
- Paid R250.
- No arrears.
- Treasurer permissions.

Family Savings:
- Pending R100 contribution.
- Paid zero.
- Owes R100.
- Member permissions.

### Sample Contributor

Community Savings:
- Confirmed R0.10 contribution.
- Owes R249.90.
- R250 arrears from a closed cycle.

Family Savings:
- No contribution.
- Owes R100.

### Current cycles

Community Savings:
- Required contribution: R250 per member.
- Target: R500.

Family Savings:
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

### Development

File: `config/dev.json`

```json
{
  "FLAVOR": "dev",
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
  "API_BASE_URL": "https://staging.ronditrack.example/api/v1"
}
```

### Production

File: `config/prod.json`

```json
{
  "FLAVOR": "prod",
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

### Future sign-out behavior

During Week 11, sign-out should:

1. Delete stored credentials.
2. Dispose the current session's provider container.
3. Create a fresh provider container for the next login.

Simply navigating to a login screen is not sufficient to clear all cached user-specific state.

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
