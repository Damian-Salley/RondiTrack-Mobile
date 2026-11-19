# Assignment 11.1: Real Data

RondiTrack Mobile uses the backend for Home, stokvel detail, activity, payout
order and close preview. The dev switcher signs in against the three seed
accounts. The selected stokvel membership determines available actions.

## Implementation

- `contract/openapi/v1.json` and `swagger_parser.yaml` pin the backend snapshot
  and scope of client generation. Generated Dart stays in `lib/core/data`.
- `lib/core/data/api_client.dart` owns the Dio instance, bearer header and
  privacy-filtered logs. Typed failures and screen messages are shared.
- The app entry point selects real repositories. Test containers can use
  `useApiProvider.overrideWithValue(false)` for all fakes.
- CI regenerates the client, detects new and modified files, and compares the
  committed backend snapshot using a selectable backend ref.

## Backend

Commits `7ec1735` and `b2652fc` publish the live contract,
distinguish close access for members and outsiders, and correct OpenAPI
metadata for numeric query parameters. [Backend PR #8](https://github.com/Damian-Salley/RondiTrack/pull/8)

## Repository swap

Commit `ee6a208` contains these files.

- `lib/main.dart`
- `lib/features/activity/activity_provider.dart`
- `lib/features/home/home_providers.dart`
- `lib/features/home/home_providers.g.dart`
- `lib/features/payouts/payout_providers.dart`
- `lib/features/stokvels/stokvel_providers.dart`
- `lib/features/stokvels/stokvel_providers.g.dart`

## Verification

- [Mobile test output](evidence/assignment-11.1/mobile-tests.txt)
- [Fresh seed live test](evidence/assignment-11.1/live-test.txt)
- [Local contract rename and analyzer diagnostic](evidence/assignment-11.1/contract-mutation.txt)
- [Three tests observed failing](evidence/assignment-11.1/test-mutations.txt).
  The deliberate changes reversed the 404 mapping, broke the Bearer scheme,
  and read paid cents in place of collected cents. The restored suite passed.
- [Evidence index and capture steps](evidence/assignment-11.1/README.md)

The cross-repo check uses the paired backend branch while `main` lacks the
snapshot. To test a different backend branch, dispatch CI using its branch
name as the `api_ref` input.
