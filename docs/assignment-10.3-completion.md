# Assignment 10.3 completion report

Implementation and local verification: 14 November 2026. Mobile work is on
`feature/assignment-10.3`, based on `74b9cd9` (fetched `origin/main` matched).
Backend work is on `feature/assignment-10.3-backend`. Nothing was pushed,
merged or submitted as a pull request. Existing work was preserved.

## Verification

- All **134 mobile tests pass**, including the original 83 tests, payout layers,
  every route in the README, the persona matrix, production/staging absence,
  first-frame switching, sign-out, and failed-membership reload regression.
- `dart analyze --fatal-infos`: **No issues found**.
- `dart format --output=none --set-exit-if-changed lib test`: **clean**.
- Locked dependency resolution passes. No dependency or lockfile changes;
  the existing pinned-version age audit remains applicable.
- Two code-generation runs pass. Generated files match committed code, and
  hashes are identical across the second run.
- Backend: **109/109 tests pass**, including the real PostgreSQL/HTTP payout
  contract test. The exported contract and its provenance are committed.
- Three deliberate mutations produced assertion failures, then were restored:
  unknown status mapped to Paid, membership access bypassed, literal colour in
  Home. Logs are `red-unknown-status.txt`, `red-membership.txt` and
  `red-architecture-colour.txt`. The final full suite passes after restoration.
- The additional real regression in `red-membership-reload.txt` demonstrated
  retained treasurer actions after a failed new-persona membership request;
  the fix and its passing test are committed separately.

Actual command output is under [evidence/assignment-10.3](evidence/assignment-10.3/).
Android build and device results are described in that folder's README.

## Compulsory requirement audit

| PDF requirement | Implementation/evidence |
|---|---|
| Read contract first; five answers and API commit | README Contract notes; `contract/provenance.json`; backend commit `729079e` |
| Necessary backend fix, separate branch/tests/commit | Server-owned GET payout order; same recipient helper as existing processing; 109 backend tests |
| Domain first, Freezed, Cents, statuses/unknown, exhaustive words | `payout.dart`; `payout_domain_test.dart`; domain commit |
| Domain interface/data fake; membership 404 and seeded order | `payout_repository.dart`, `fake_payout_repository.dart`; fake tests |
| Value-keyed family; sealed loading/empty/data/failure; independent cycles | `payout_provider.dart`; provider tests; shared `ViewState` |
| Light/dark measured payout colours | `StatusColors.payout`; README token table; contrast and screen tests |
| Typed route under cycle; cold auth restoration; correct tab/back | `PayoutsRoute`; route test; Android device evidence |
| Screen last; server order/amount/status/next; membership actions | `payout_screen.dart`; screen tests; persona matrix |
| No sorting, totals, paid count or next computation in mobile | Screen iterates unchanged response; unusual position/order test |
| 360 dp/200% text; dark tokens | Screen and existing layout tests; device captures |
| Lerato Treasurer/Member; Sipho Member; third persona empty | Existing seeds retained through documented display aliases; persona tests/table |
| Dev-only switcher; absent widget/route in staging/prod | Config-gated construction in shell/sign-in; both non-dev config tests |
| Nothing from previous persona, including sign-out | First-frame menu tests with both stokvels open; payouts and failed-reload tests |
| Every screen reachable; Routes table tested | Cycle's payouts button; shell; `routes_table_test.dart` |
| Architecture checks run in CI; exceptions documented | `architecture_test.dart`, picked up by existing CI `flutter test`; no exceptions |
| Standalone Dart 3 refactor, unchanged tests before/after | `da5f84d`: payout colour mapping becomes exhaustive; 133 tests before and after |
| Three tests deliberately seen red | Saved mutation logs; PR description explains each change |
| Reviewer-facing architecture argument/screenshots/recording | [PR description](assignment-10.3-pr-description.md), evidence README |
| Local commits per layer, each clean analysis/passing tests | Commit list and per-layer `*-analysis.txt` / `*-tests.txt` |
| Optional stretch challenges | Skipped |
| Hosted CI, PR links and final submission | Owner steps below; no hosted success is claimed |

## Implementation commits

| Commit | Layer / result |
|---|---|
| `bd3a2e9` | Domain — 85 tests |
| `dbae4a8` | Fake — 91 tests |
| `8b7a71b` | Provider — 94 tests |
| `e139832` | Theme — 95 tests |
| `2e8aad7` | Route — 96 tests |
| `850461e` | Screen — 101 tests |
| `6a90212` | Personas and every-address checks — 131 tests |
| `c5da91e` | Architecture — 133 tests |
| `da5f84d` | Standalone Dart 3 refactor — unchanged 133 tests |
| `e005905` | Failed-membership reload regression fix — 134 tests |
| Backend `729079e` | Payout read contract — 109 backend tests |

The final documentation/evidence commit follows these; use `git log main..HEAD`
for its hash. The existing 10.1/10.2 evidence and completion report remain intact.

## Scope and owner steps

All screens still use fakes. Payout recording retains the existing Week 11
placeholder; the assignment asks for the rotation/payout view and permitted
action visibility, not a financial write flow. The API remains authoritative for
order, next, money and access. No new packages or migrations were needed.

After your review, publish the backend branch and open its separate PR, then
publish mobile and open **Assignment 10.3: Foundations Capstone**. Use the prepared
description, attach the real evidence, link the backend PR and a green hosted CI
run. Those publishing/submission steps were explicitly reserved for you.
