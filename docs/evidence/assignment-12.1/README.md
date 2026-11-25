# Assignment 12.1 evidence

- [Windows light golden](../../../test/goldens/windows/stokvel_card_light.png) and [Windows dark golden](../../../test/goldens/windows/stokvel_card_dark.png). The images were inspected in both themes. [CI light](../../../test/goldens/ci/stokvel_card_light.png) and [CI dark](../../../test/goldens/ci/stokvel_card_dark.png) use block text. Hosted Linux diffs on the first baseline were thin paint differences at fractional column and label offsets. The test grid now uses whole-pixel columns and integer Ahem letter spacing. The adjusted images were reviewed locally before committing.
- All three key tests fail when the outbox replaces the stored key on send. [Broken](outbox-broken.txt) · [Restored](outbox-restored.txt)
- Converting a Home repository error to an empty list fails the notifier transition test. [Broken](notifier-broken.txt) · [Restored](notifier-restored.txt)
- Reducing the card padding from 20 to 12 changes both themes and golden variants. [Broken](golden-broken.txt) · [Restored](golden-restored.txt)
- Allowing unfiltered breadcrumbs through the scrubber leaks a synthetic name and other fixture data. [Broken](scrubber-broken.txt) · [Restored](scrubber-restored.txt)
- [Publication dates for all 143 hosted package versions](dependency-age.txt). Flutter SDK packages follow the pinned Flutter version.

- Loading the old history list made the rebuild regression fail. The count fell from one previous row rebuild to zero on Windows x64 in Flutter debug widget tests, using 300 synthetic rows at 200% text scale. [Old list](rebuild-broken.txt) · [Restored](rebuild-after.txt)

- Assignment 11.3 baseline had 187 passing fast tests and three skipped live tests. Coverage was 1,759 of 2,338 reported lines (75.24%). Both local configured time-zone runs passed 208 fast tests and covered 1,873 of 2,415 lines (77.56%). [UTC tests](tests-UTC.txt) · [UTC coverage](coverage-UTC.txt) · [Johannesburg tests](tests-Africa-Johannesburg.txt) · [Johannesburg coverage](coverage-Africa-Johannesburg.txt)
- The dedicated database script inserted and deleted exactly 300 contribution fixtures. [Fixture commands](fixtures.txt)

- All three isolated live API tests passed when the fresh-seed checks ran before payment replay. [Live API output](live-api.txt)

- DevTools widget-build instrumentation recorded 9 ListTile builds before the change and 3 afterward on the Windows x64 Flutter debug renderer at 200% text scale. [Before VM timeline](devtools-before.json) · [After VM timeline](devtools-after.json)
- Hosted Linux UTC and Africa/Johannesburg each passed 206 tests and enforced 77.43% coverage. The backend contract passed. [Hosted matrix](https://github.com/Damian-Salley/RondiTrack-Mobile/actions/runs/45580262226)

## Pending verification

- The Android journey passed three consecutive times on the hosted Android API 34 emulator. Two local builds failed before installation. A later isolated-cache build succeeded but the local emulator disconnected. The screenshot from the first hosted run could not be retrieved after app uninstall. [Three hosted passes](android-hosted.txt) · [Local build diagnostics](android-build-failures.txt)

- A real Sentry event from a private DSN using synthetic data.
- Confirm the validated Android screenshot artifact from the latest CI run.
