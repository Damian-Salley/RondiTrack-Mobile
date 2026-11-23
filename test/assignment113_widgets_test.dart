import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_mobile/core/api_failure.dart';
import 'package:ronditrack_mobile/core/data/api_client.dart';
import 'package:ronditrack_mobile/core/money.dart';
import 'package:ronditrack_mobile/features/contributions/contribution_providers.dart';
import 'package:ronditrack_mobile/features/contributions/data/contribution_history.dart';
import 'package:ronditrack_mobile/features/contributions/domain/contribution_page.dart';
import 'package:ronditrack_mobile/features/contributions/domain/payment_intent.dart';
import 'package:ronditrack_mobile/features/contributions/presentation/contribution_list_screen.dart';
import 'package:ronditrack_mobile/features/contributions/presentation/contribution_paging.dart';
import 'package:ronditrack_mobile/features/contributions/presentation/pay_form.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/models.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/status.dart';
import 'package:ronditrack_mobile/features/stokvels/presentation/stokvel_form.dart';
import 'package:ronditrack_mobile/l10n/generated/app_localizations.dart';
import 'package:ronditrack_mobile/l10n/generated/app_localizations_af.dart';
import 'package:ronditrack_mobile/l10n/generated/app_localizations_en.dart';

const PaymentTarget _target = (stokvelId: 1, cycleId: 11, userId: 8);
const _row = Contribution(
  userId: 8,
  stokvelId: 1,
  cycleId: 11,
  memberName: 'Sample member',
  amount: Cents(45075),
  status: ContributionStatus.paid,
);

Widget _app(Widget body, {String language = 'en'}) => MaterialApp(
  locale: Locale(language),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(context)
        .copyWith(textScaler: const TextScaler.linear(2)),
    child: child!,
  ),
  home: body,
);

void main() {
  test('rand input and exact JSON decimal tokens', () {
    for (final value in [
      '1250,50',
      '1250.50',
      'R 1 250,50',
      'R\u00A01\u00A0250,50',
    ]) {
      final amount = parseRands(value) as ParsedMoney;
      expect(amount.amount, const Cents(125050));
      expect(randDecimal(amount.amount), '1250.50');
    }
    expect((parseRands('8,5') as ParsedMoney).amount, const Cents(850));
    for (final value in [
      '',
      '1,250.50',
      '-1',
      '0',
      '1.234',
      '1e2',
      'abc',
      '90071992547409.92',
    ]) {
      expect(isContributionAmount(parseRands(value)), isFalse, reason: value);
    }
    expect(
      randDecimal(const Cents(maximumContributionCents)),
      '90071992547409.91',
    );
  });

  test('English and Afrikaans use ICU member plurals', () {
    final en = AppLocalizationsEn();
    final af = AppLocalizationsAf();
    expect([0, 1, 6].map(en.memberCount), [
      '0 members',
      '1 member',
      '6 members',
    ]);
    expect([0, 1, 6].map(af.memberCount), ['0 lede', '1 lid', '6 lede']);
  });

  for (final language in ['en', 'af']) {
    testWidgets('pay form in $language keeps input after field error at 200%', (
      tester,
    ) async {
      final messages = StreamController<PaymentNotice>();
      addTearDown(messages.close);
      final semantics = tester.ensureSemantics();
      final strings = language == 'en'
          ? AppLocalizationsEn()
          : AppLocalizationsAf();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            pendingPaymentsProvider.overrideWith((ref) => Stream.value([])),
            paymentNoticeProvider.overrideWith((ref) => messages.stream),
          ],
          child: _app(
            const PayForm(target: _target, suggestedAmount: Cents(4000)),
            language: language,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(strings.payContribution), findsOneWidget);
      expect(find.text(strings.amount), findsOneWidget);
      final field = find.byType(TextFormField);
      await tester.enterText(field, 'R 1 250,50');
      const message = 'Amount outside the allowed range.';
      messages.add((
        payment: PaymentIntent(
          key: 'demo',
          target: _target,
          amount: const Cents(125050),
          createdAt: DateTime.utc(2026),
        ),
        disposition: PaymentDisposition.refused,
        failure: const ValidationFailure(null, {
          'amountInCents': [message],
        }),
      ));
      await tester.pumpAndSettle();
      expect(
        find.descendant(of: field, matching: find.text(message)),
        findsOneWidget,
      );
      expect(
        tester.widget<EditableText>(find.byType(EditableText)).controller.text,
        'R 1 250,50',
      );
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      semantics.dispose();
    });
  }

  testWidgets(
    'create sends exact rands and keeps fields after a server error',
    (tester) async {
      final dio = Dio();
      addTearDown(dio.close);
      final adapter = _InvalidName();
      dio.httpClientAdapter = adapter;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [apiClientProvider.overrideWithValue(ApiClient(dio))],
          child: _app(const StokvelForm()),
        ),
      );
      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), '90550');
      await tester.enterText(fields.at(1), 'Savings');
      await tester.enterText(fields.at(2), '90071992547409,91');
      final save = find.widgetWithText(FilledButton, 'Save');
      await tester.ensureVisible(save);
      await tester.tap(save);
      await tester.pumpAndSettle();
      expect(adapter.body, contains('"contributionAmount":90071992547409.91'));
      expect(
        find.descendant(
          of: fields.at(1),
          matching: find.text('Choose another name.'),
        ),
        findsOneWidget,
      );
      expect(find.text('90071992547409,91'), findsOneWidget);
    },
  );

  test(
    'changing filters during pagination keeps one request in flight',
    () async {
      final history = _History();
      addTearDown(history.dispose);
      final paging = ContributionPaging(
        (filters, token) => history.fetch(1, filters, token),
      );
      addTearDown(paging.dispose);
      final initial = paging.refresh();
      expect(history.calls.single.token, isNull);
      history.calls.single.response.complete((rows: [_row], nextToken: 'old'));
      await initial;

      final next = paging.next();
      expect(history.calls.last.token, 'old');
      const filters = (
        cycleId: 11,
        status: ContributionStatus.paid,
        memberId: null,
        from: null,
        to: null,
      );
      final changed = paging.changeFilters(filters);
      expect(history.calls, hasLength(2));
      history.calls.last.response.complete((rows: [_row], nextToken: null));
      await Future<void>.delayed(Duration.zero);
      expect(history.calls, hasLength(3));
      expect(history.calls.last.token, isNull);
      expect(history.calls.last.filters, filters);
      expect(paging.rows, isEmpty);
      history.calls.last.response.complete((rows: [_row], nextToken: null));
      await Future.wait([next, changed]);
      expect(paging.rows, [_row]);
      final refresh = paging.refresh();
      expect(paging.rows, [_row]);
      history.calls.last.response.complete((
        rows: <Contribution>[],
        nextToken: null,
      ));
      await refresh;
      expect(paging.rows, isEmpty);
    },
  );

  testWidgets(
    'contribution list presents six distinct states and 48 dp controls',
    (tester) async {
      final history = _History();
      addTearDown(history.dispose);
      await tester.binding.setSurfaceSize(const Size(800, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [contributionHistoryProvider.overrideWithValue(history)],
          child: _app(const ContributionListScreen(stokvelId: 1)),
        ),
      );
      expect(find.text('Loading contributions'), findsOneWidget);
      history.calls.last.response.completeError(const OfflineFailure());
      await tester.pumpAndSettle();
      expect(find.text('Couldn’t load contributions.'), findsOneWidget);

      await tester.tap(find.text('Try again'));
      history.calls.last.response.complete((
        rows: <Contribution>[],
        nextToken: null,
      ));
      await tester.pumpAndSettle();
      expect(find.text('There are no contributions yet.'), findsOneWidget);

      await tester.tap(
        find.byType(DropdownButtonFormField<ContributionStatus>),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Confirmed').last);
      history.calls.last.response.complete((
        rows: <Contribution>[],
        nextToken: null,
      ));
      await tester.pumpAndSettle();
      expect(
        find.text('No contributions match these filters.'),
        findsOneWidget,
      );

      await tester.tap(find.text('Clear filters'));
      history.calls.last.response.complete((rows: [_row], nextToken: 'more'));
      await tester.pumpAndSettle();
      final loadMore = find.text('Load more contributions');
      await tester.ensureVisible(loadMore);
      await tester.tap(loadMore);
      history.calls.last.response.completeError(const ServerFailure(null));
      await tester.pumpAndSettle();
      expect(find.text('Sample member'), findsOneWidget);
      expect(find.text('Paid'), findsOneWidget);
      expect(find.text('Couldn’t load the next page.'), findsOneWidget);

      await tester.tap(find.text('Try again'));
      history.calls.last.response.complete((
        rows: <Contribution>[],
        nextToken: null,
      ));
      await tester.pumpAndSettle();
      expect(find.text('End of contributions'), findsOneWidget);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      expect(tester.takeException(), isNull);
      semantics.dispose();
    },
  );
}

class _History extends ContributionHistory {
  new([Dio? dio]) : this._(dio ?? Dio());

  new _(this._dio) : super(ApiClient(_dio));

  final Dio _dio;
  final calls =
      <
        ({
          ContributionFilters filters,
          String? token,
          Completer<ContributionPage> response,
        })
      >[];

  @override
  Future<ContributionPage> fetch(
    int stokvelId,
    ContributionFilters filters,
    String? token,
  ) {
    final response = Completer<ContributionPage>();
    calls.add((filters: filters, token: token, response: response));
    return response.future;
  }

  @override
  Future<FilterOptions> options(int stokvelId) async => (
    cycles: [(id: 11, number: 1)],
    members: [(id: 8, name: 'Sample member')],
  );

  void dispose() => _dio.close();
}

class _InvalidName implements HttpClientAdapter {
  Object? body;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    body = options.data;
    return ResponseBody.fromString(
      '{"errors":{"name":["Choose another name."]}}',
      400,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
