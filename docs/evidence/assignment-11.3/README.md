# Assignment 11.3 verification

- Backend PR #9 implements the combined filters, stale-version checks, and restart-safe payment receipts. The PostgreSQL-backed verification passed 29 tests, and the full hosted workflow passed. [Backend PR #9](https://github.com/Damian-Salley/RondiTrack/pull/9) [Hosted backend workflow](https://github.com/Damian-Salley/RondiTrack/actions/runs/45258421635)
- The mobile live test records one contribution after sending the same key twice and verifies that a stale edit receives HTTP 409. It runs only against a disposable development API when `RONDI_LIVE_URL` and `RONDI_LIVE_PASSWORD` are set. [Live test output](live-test.txt)
- Three deliberate regressions turned their tests red. I sent a fresh UUID on every payment attempt, used UTC midnight as the South African day start, and dropped one digit from the rand fraction. All three passed after restoring the implementation. [Red and green test output](red-green.txt)
- The Linux workflow passed the full non-live suite in both time zones, including the 00:30 SAST boundary case. [UTC](https://github.com/Damian-Salley/RondiTrack-Mobile/actions/runs/45256799919/job/137980636660) [Africa/Johannesburg](https://github.com/Damian-Salley/RondiTrack-Mobile/actions/runs/45256799919/job/137980636334)
- The English and Afrikaans pay forms passed automated layout, form-field error, and Android tap-target checks at 200% text. The Afrikaans catalog is marked as a draft pending first-language review.

## Android API 36 dev build

The test ran on a disposable development API and a PostgreSQL fixture. The app started in airplane mode with the last successful Home update visible. The pending R41,25 stayed in Drift through a force-stop and restart. After reconnection, the app showed the contribution as paid, and PostgreSQL held one row and one matching receipt. [Offline Home](home-airplane-after-restart.png) [Payment queued](payment-pending-airplane.png) [Pending after restart](payment-pending-after-restart.png) [Paid after reconnection](payment-after-reconnect.png) [Drift and PostgreSQL key evidence](offline-payment.txt)

Sign-out asked before discarding the queued payment. Cancelling kept the existing key and amount. [Confirmation prompt](discard-payment-confirmation.png)

The edit form retained the R41,25 draft after a stale-version refusal and showed the server's R42,50 value. [Stale edit and latest details](stale-edit.png)

The emulator used UTC while the app selected 1 November in South Africa. The only matching row showed 00:30 SAST. [Filtered contribution list](contributions-november-1-sast.png)

The pay form displayed the localized validation error beneath the amount and kept the input in both languages. The Afrikaans choice was still active after an app restart. [English field error](pay-error-en.png) [Afrikaans field error](pay-error-af.png)

TalkBack was bound with spoken feedback and touch exploration enabled. At Android font scale 2.0, focus reached the amount field and its wrapped validation error with the keyboard open. The screenshots show focus and layout. [Amount field](talkback-pay-200-percent.png) [Validation error](talkback-error-200-percent.png)
