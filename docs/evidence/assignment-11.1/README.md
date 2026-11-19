# Assignment 11.1 evidence

- [Live provider test and outage timing](live-test.txt)
- [Mobile regression suite output](mobile-tests.txt)
- [Three deliberate regressions and failing assertions](test-mutations.txt)
- [Local contract comparison and mapper failure](contract-mutation.txt)

## Dependency pins

The package registry reported these publication dates. All six versions were
at least 14 days old on 19 November 2026.

| Package | Pin | Published (UTC) |
| --- | --- | --- |
| dio | 5.11.1 | 4 September 2026 |
| retrofit | 4.10.0 | 13 August 2026 |
| json_annotation | 4.12.0 | 15 May 2026 |
| json_serializable | 6.15.2 | 20 October 2026 |
| retrofit_generator | 10.3.3 | 1 November 2026 |
| swagger_parser | 1.45.1 | 30 October 2026 |

## Device screenshots

Use the dev setup in the project README with a disposable database. Sign in as
Lerato and capture Home. From Community and Family detail, record the actual
stokvel and cycle IDs. Use `adb shell am start -a android.intent.action.VIEW
-d "ronditrack-dev://app/stokvels/<id>"` for an existing stokvel Lerato does
not belong to. A temporary stokvel created by New Member in the disposable
database supplies such a fixture.

For the 403, open
`ronditrack-dev://app/stokvels/<family-id>/cycles/<family-cycle-id>/close-preview`
as Lerato. For the 429, make six login requests inside one rate-limit window.
The server's wait in seconds should be visible on the sixth attempt.

For the server reference, keep the dev backend running and stop only the
disposable PostgreSQL instance. Request fresh detail from the phone. Capture the
failure reference alongside the same correlation ID in the backend log.

## Hosted CI and submission

After push permission, publish the backend fix and link its PR. Publish the
mobile branch and create the PR with the assignment title. To reproduce the
two hosted red runs, publish a throwaway backend branch with
`stokvelName` renamed in the Home response and re-export its contract.
Dispatch mobile CI with that ref for the comparison failure. Next copy the
renamed contract to a throwaway mobile branch and regenerate to show the
mapper error. Save both run links and screenshots, then remove the throwaway
branches. Run the final workflow against the matching contract and link the
green run.
