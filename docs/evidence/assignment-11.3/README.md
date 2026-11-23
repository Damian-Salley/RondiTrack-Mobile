# Assignment 11.3 verification

- Backend PR #9 implements the combined filters, stale-version checks, and restart-safe payment receipts. The PostgreSQL-backed verification passed 29 tests. [Backend PR #9](https://github.com/Damian-Salley/RondiTrack/pull/9)
- The mobile live test records one contribution after sending the same key twice and verifies that a stale edit receives HTTP 409. It runs only against a disposable development API when `RONDI_LIVE_URL` and `RONDI_LIVE_PASSWORD` are set.
- Three deliberate regressions turned their tests red. I sent a fresh UUID on every payment attempt, used UTC midnight as the South African day start, and dropped one digit from the rand fraction. All three passed after restoring the implementation. [Red and green test output](red-green.txt)
- The Linux workflow defines separate `TZ=UTC` and `TZ=Africa/Johannesburg` jobs. Both run the full non-live suite, including the 00:30 SAST boundary test.
- The English and Afrikaans pay forms passed automated layout, form-field error, and Android tap-target checks at 200% text. The Afrikaans catalog is marked as a draft pending first-language review.
