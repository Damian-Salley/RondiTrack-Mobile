# Assignment 11.2 verification

Verified on 21 November 2026 with the dev Android build and the local
RondiTrack API. The seven contract answers and backend revision are in the
[mobile README](../../../README.md#auth).

## Android

All 13 captures are available as [redacted PNGs](redacted/). Opaque masks
cover form values, account identifiers, stokvel names and financial details.
The same alias identifies the target stokvel across the join and detail views.

| Check | Observed result |
| --- | --- |
| Cold start with a stored session | [Restore splash](redacted/restoring.png) and [restored Home](redacted/restored-home.png) |
| Cold start in airplane mode | [Offline splash with Try again and Sign out](redacted/offline-restore.png) |
| Shared phone | [First Home](redacted/first-person-home.png), [Treasurer stokvel](redacted/first-person-treasurer.png), [dev picker](redacted/dev-persona-picker.png), and [next account’s empty Home](redacted/next-person-home.png) |
| Cold invite link opened while signed out | [Sign-in](redacted/join-signed-out.png) and [the intended stokvel after authentication](redacted/join-landed.png) |
| Sign-in errors | [Generic incorrect-credentials message](redacted/wrong-password.png) and [live 429 countdown with disabled submission](redacted/rate-limit.png) |
| Registration errors | [Registration form](redacted/registration-form.png) and [API error beneath the password field](redacted/registration-error.png) |

The shared-phone run used the dev application's encrypted preferences file.
A read-only `adb run-as` check counted string entries in
`shared_prefs/FlutterSecureStorage.xml` while the app was signed in and after
Profile sign-out in airplane mode. The count changed from **1** to **0**.
The evidence records counts and leaves encrypted values out of the report.
The assignment asks for Device Explorer views. The available device record
uses ADB counts from the same preferences file.
The sign-out regression test delays secure deletion and checks that the UI
auth state reports completion only after the delete finishes.

## Live API

Both live tests passed against the local API in strict reuse mode. The
rotation test sent three concurrent Home requests with a spoiled access
token. The application interceptor reported these statuses in the live test
console. Correlation IDs are omitted here.
The assignment also asks for the dev build’s Run console. This trace comes
from the live test console.

```text
GET /api/v1/me/home 401 20ms
GET /api/v1/me/home 401 22ms
GET /api/v1/me/home 401 22ms
GET /api/v1/me/home 200 167ms
GET /api/v1/me/home 200 167ms
GET /api/v1/me/home 200 168ms
One refresh, three successful retries, reuse revoked the replacement,
and logout revoked its cookie.
00:03 +2: All tests passed!
```

## Deliberately broken checks

| Temporary change | Observed test failure |
| --- | --- |
| Removed the shared refresh future | Three expired requests no longer all succeeded. |
| Accepted the first cookie regardless of its name | The parser returned the unrelated cookie value. |
| Allowed a completed refresh to write after the session changed | The test found an access token after sign-out. |

All changes above were reverted and the session tests passed on the restored
source. The full suite passed **174 non-live tests**. Dart formatting and
strict analysis passed. The publication-date audit checked **114** pinned
hosted packages. The newest was published on 3 November 2026.

[Hosted CI for the sign-out regression check](https://github.com/Damian-Salley/RondiTrack-Mobile/actions/runs/44916214960)
