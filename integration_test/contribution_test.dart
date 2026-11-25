import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ronditrack_mobile/app/ronditrack_app.dart';
import 'package:ronditrack_mobile/core/data/offline_database.dart';
import 'package:ronditrack_mobile/core/offline_mode.dart';
import 'package:ronditrack_mobile/core/offline_refresh.dart';
import 'package:ronditrack_mobile/features/contributions/contribution_providers.dart';
import 'package:ronditrack_mobile/features/contributions/data/payment_outbox.dart';
import 'package:ronditrack_mobile/features/contributions/domain/payment_intent.dart';
import 'package:ronditrack_mobile/features/session/domain/persona.dart';
import 'package:ronditrack_mobile/features/stokvels/data/fake_stokvel_repository.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/models.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/status.dart';
import 'package:ronditrack_mobile/features/stokvels/stokvel_providers.dart';

class _CycleRepository extends FakeStokvelRepository {
  new() : super(Persona.demo, delay: Duration.zero);

  PaymentIntent? saved;

  @override
  Future<StokvelDetail?> fetchDetail(int stokvelId) async {
    final detail = await super.fetchDetail(stokvelId);
    if (detail == null) return null;
    final payment = saved;
    return detail.copyWith(
      contributions: [
        if (payment != null)
          Contribution(
            userId: payment.target.userId,
            stokvelId: payment.target.stokvelId,
            cycleId: payment.target.cycleId,
            memberName: 'Synthetic payer',
            amount: payment.amount,
            status: ContributionStatus.paid,
          ),
      ],
    );
  }
}

Future<void> _waitFor(WidgetTester tester, Finder finder) async {
  final watch = Stopwatch()..start();
  while (finder.evaluate().isEmpty &&
      watch.elapsed < const Duration(seconds: 15)) {
    await tester.pump(const Duration(milliseconds: 100));
    await Future<void>.delayed(const Duration(milliseconds: 30));
  }
  expect(finder, findsWidgets);
}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('sign in, record contribution, and reconcile the outbox', (
    tester,
  ) async {
    expect(const String.fromEnvironment('FLAVOR'), 'dev');
    final db = OfflineDatabase(NativeDatabase.memory());
    final repository = _CycleRepository();
    final container = ProviderContainer(
      overrides: [
        offlineStorageEnabledProvider.overrideWithValue(true),
        offlineDatabaseProvider.overrideWithValue(db),
        stokvelRepositoryProvider.overrideWithValue(repository),
        paymentOutboxSyncProvider.overrideWith((ref) {
          final sync = PaymentOutboxSync(
            ref.read(paymentOutboxStoreProvider),
            (payment) async => repository.saved = payment,
            ref.read(offlineRefreshProvider).add,
          );
          ref.onDispose(sync.dispose);
          return sync;
        }),
      ],
    );
    addTearDown(() async {
      container.dispose();
      await db.close();
    });
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const RondiTrackApp(),
      ),
    );
    final email = find.byType(TextFormField).first;
    await _waitFor(tester, email);
    await tester.enterText(email, Persona.demo.email);
    await tester.tap(find.text('Sign in').last);
    final stokvel = find.text('Community Savings');
    await _waitFor(tester, stokvel);
    await tester.tap(stokvel.first);
    final pay = find.widgetWithText(OutlinedButton, 'Pay');
    await _waitFor(tester, pay);
    await tester.ensureVisible(pay);
    await tester.tap(pay);
    final submit = find.widgetWithText(FilledButton, 'Pay');
    await _waitFor(tester, submit);
    await tester.enterText(find.byType(TextFormField), '123,45');
    await tester.tap(submit);
    await _waitFor(tester, find.text('Payment recorded.'));
    await tester.pageBack();
    await _waitFor(tester, find.text('Synthetic payer'));
    expect(find.text('R\u00A0123,45'), findsOneWidget);
    expect(repository.saved?.amount.value, 12345);
    expect(await container.read(paymentOutboxStoreProvider).read(), isEmpty);

    await binding.convertFlutterSurfaceToImage();
    await tester.pump();
    final image = await binding.takeScreenshot('assignment-12.1-contribution');
    await File('${Directory.systemTemp.path}/assignment-12.1-contribution.png')
        .writeAsBytes(image);
  });
}
