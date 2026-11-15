# Assignment 10.3: Foundations Capstone

Adds a cycle's rotation and payouts view through domain, fake, provider, theme,
typed route and screen, in that commit order. The app displays the API's order,
amounts and next-recipient status unchanged. A dev-only menu switches the three
seed personas through fake sign-in while preserving the current address.

The API previously exposed only payout processing. Backend branch
`feature/assignment-10.3-backend`, commit `729079e`, adds the required read
endpoint and reuses the processing recipient rule. **Backend PR: owner to add
after review/publication.** No migrations, packages or payout-processing rule
changes were needed. Contract source/hash are in `contract/provenance.json`.

## Try it

1. `flutter run --flavor dev --dart-define-from-file=config/dev.json`.
2. Sign in as Lerato (`assignment71-demo@ronditrack.example`). Open Community
   Savings → Open cycle → View rotation and payouts. Lerato is Next; the
   Treasurer action is present. Record payout remains a Week 11 placeholder.
3. Select Sipho using **Dev persona: Lerato**. The action disappears. Mabena
   Family has only Member actions and its payout view has no order yet.
4. Select New Member: Home explains how to get an invite; links to others'
   stokvels/cycles return not found.
5. Cold link:
   `adb shell am start -W -a android.intent.action.VIEW -d "ronditrack-dev://app/stokvels/1/cycles/101/payouts"`.
   Sign in; back goes to cycle, stokvel, list.
6. Run with staging/prod and matching config: no persona menu or seed shortcuts
   are constructed, and `/dev/personas` is not found. Try system dark mode and
   360 dp with 200% text.

## Boundaries and evidence

| Boundary | What it did this week | Code / test |
|---|---|---|
| Domain repository interfaces | Fake access/order behavior tested without Flutter or API calls | `payout_repository.dart`; `payout_fake_test.dart` |
| Composition roots | Persona changes replace repositories; screens never import fakes | `payout_providers.dart`; `persona_test.dart`; `architecture_test.dart` |
| Freezed domain and Cents | Keeps exact money and API row shape; unknown status survives | `payout.dart`; `payout_domain_test.dart` |
| Sealed view states | Distinguishes empty order from data/failure and discards old-persona frames | `view_state.dart`; `payout_provider_test.dart`; `persona_test.dart` |
| Value-keyed families | Two cycles maintain independent state; rebuilds reuse stable record keys | `payout_provider.dart`; independent-cycle provider test |
| Typed routes and auth gate | Cold payout link survives sign-in in the right tab and back chain | `router.dart`, `auth_redirect.dart`; `payout_route_test.dart`, `routes_table_test.dart` |
| Theme extension | All statuses reuse measured accessible light/dark pairs; new enum cases must be handled | `app_theme.dart`; `payout_theme_test.dart`, `payout_screen_test.dart`; standalone `da5f84d` |
| Runtime flavour config | Prevents construction of dev switching controls in staging/prod | `app_config.dart`, `main.dart`, shell/sign-in; non-dev persona tests |
| Membership-based actions | Lerato's Treasury permission does not follow her into Family or follow Sipho | `allowedActions`; per-screen matrix and failed-reload test |
| Source architecture guard | Fails on literal feature colours and screen data/Dio/Drift imports in CI | `architecture_test.dart`; actual red colour-mutation log |

**Boundary I would remove:** the separate selected-persona `Session` provider
once real authentication replaces fakes. `authProvider` already holds that same
person, so `Auth.signIn` must synchronise both and `signOut` must invalidate the
session. It costs two state transitions and an extra dependency chain. Removing
it now without updating `home_providers`, `stokvel_providers` and
`payout_providers` would stop them reacting to sign-in (or fail compilation if
the provider is deleted). Watching authenticated identity directly would replace
that behavior. The first-frame and sign-out tests would catch an incomplete
migration immediately. It remains here to preserve the 10.1/10.2 composition.

## Tests deliberately seen fail

| Test | What I broke | Actual failure evidence |
|---|---|---|
| Domain API status mapping | Changed the unknown-string fallback to Paid | `red-unknown-status.txt`: Reversed expected unknown, got paid |
| Fake membership access | Bypassed the not-found condition | `red-membership.txt`: newcomer/missing-cycle requests returned data rather than throwing |
| Feature architecture | Added `Color(0xFF000000)` to Home | `red-architecture-colour.txt`: feature-colour boundary assertion failed |

Each mutation was restored byte-for-byte. Final full verification passes after
restoration. An additional regression test first failed on the real retained
membership bug (`red-membership-reload.txt`); `e005905` fixes stale Treasurer
actions when the new persona's membership request fails. The Dart 3 refactor
commit changes no tests; the same 133 tests pass before/after it.

## Local validation and evidence

134/134 mobile tests; clean strict analysis and formatting; locked resolution;
two stable generation runs matching committed code. Backend: 109/109 tests.
Android build/device results and real captures are indexed in
[the evidence README](evidence/assignment-10.3/README.md).

Required captures: [Lerato payouts](evidence/assignment-10.3/payouts-lerato.png),
[Sipho payouts](evidence/assignment-10.3/payouts-sipho.png),
[empty Home](evidence/assignment-10.3/home-new-member.png),
[dev switcher](evidence/assignment-10.3/profile-dev-switcher.png),
[same prod screen](evidence/assignment-10.3/profile-prod.png),
[persona switch with Family open](evidence/assignment-10.3/persona-switch.mp4).

**Hosted CI run: owner to add after publication.** No hosted success is claimed
for these local commits. Existing CI runs code generation, strict analysis,
formatting and the full suite including architecture tests.

Optional stretch challenges, real authentication and financial writes were left
out. Existing 10.1/10.2 tests and evidence remain. No push, merge or PR was made
while implementing this ticket.
