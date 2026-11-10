# Assignment 10.1: Foundations and State

RondiTrack now has a Flutter mobile application with membership-scoped roles, integer-cent money, Home summaries and stokvel detail on three seed personas. Riverpod owns screen loading and disposal; switching stokvels immediately shows the selected stokvel loading, without retaining the previous stokvel's contributions.

Three Android flavours have separate IDs/names and validated configs. Strict analysis, Riverpod linting, pinned dependencies, Freezed generation, a contract snapshot and a PR CI workflow are included. Repository interfaces keep the widgets independent of fake/API implementations for Week 11.

Validation: repository-wide Dart formatting, reproducible code generation, `dart analyze --fatal-infos`, 63 mobile tests, and debug APK builds for dev/staging/prod passed locally. The full unfiltered backend suite passed 108/108 tests, including 24 focused decimal/cents cases. Decimal request validation rejects sub-cent precision, nonpositive amounts and overflow; confirmation availability is decided in the domain function, and generated Android reports are ignored.

Submission links still to fill after authorized publication:

- Deliberate-red Riverpod lint PR/run: **pending**
- Fixed green CI run: **pending**
- Separate backend contract/seed fix PR: **pending**
- Backend source commit for the final contract export: **pending** (base plus local-fix hashes are recorded now)

Evidence prepared in this branch:

- [All three installed flavours](evidence/launcher-three-flavours.png)
- [Treasurer-in-one Home](evidence/home-treasurer.png)
- [Zero-membership Home](evidence/home-empty.png)
- [Treasurer stokvel](evidence/detail-treasurer.png)
- [Member stokvel](evidence/detail-member.png)
- [Failure with retry](evidence/home-failure.png)
- [Stokvel switch recording](evidence/stokvel-switch.mp4)
- [ID-only disposal log](evidence/emulator-disposal.txt)
- [Local Riverpod lint failure](evidence/riverpod-lint-analysis.txt)

Upload the recording to the PR if GitHub does not render the repository MP4 link inline. The [completion report](completion-report.md) distinguishes verified local implementation from remaining remote hand-in requirements. Staging/prod API addresses are documented placeholders; no real API connections are enabled in this assignment.
