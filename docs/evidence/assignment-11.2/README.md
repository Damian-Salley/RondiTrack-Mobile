# Assignment 11.2 verification

Verified on 21 November 2026 with the dev Android build and the local
RondiTrack API. The seven contract answers and backend revision are in the
[mobile README](../../../README.md#auth).

## Android

The captures were saved in the local workspace. The results below describe
the device run without printing account identifiers or balances.

| Check | Observed result |
| --- | --- |
| Cold start with a stored session | The splash appeared and Home loaded after reopening the app. |
| Cold start in airplane mode | The splash showed Try again and Sign out. |
| Shared phone | The first fixture opened its Treasurer stokvel. The dev picker filled the second fixture's email. After sign-out and the next sign-in, the second fixture saw an empty Home. |
| Cold invite link opened while signed out | The link reached sign-in and opened the intended stokvel after authentication. |
| Sign-in errors | A wrong password displayed the generic message. A live 429 displayed the wait time and disabled submission. |
| Registration errors | The API's password-length error appeared under the password field. |

The shared-phone run used the dev application's encrypted preferences file.
A read-only `adb run-as` check counted string entries in
`shared_prefs/FlutterSecureStorage.xml` while the app was signed in and after
Profile sign-out in airplane mode. The count changed from **1** to **0**.
The evidence records counts and leaves encrypted values out of the report.
The sign-out regression test delays secure deletion and checks that the UI
auth state reports completion only after the delete finishes.

## Live API

Both live tests passed against the local API in strict reuse mode. The
rotation test sent three concurrent Home requests with a spoiled access
token. The application interceptor reported these statuses in the live test
console. Correlation IDs are omitted here.

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
