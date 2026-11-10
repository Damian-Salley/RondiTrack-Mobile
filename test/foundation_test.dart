import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_mobile/app/app_config.dart';
import 'package:ronditrack_mobile/core/money.dart';

void main() {
  // Verify that invalid application configurations are rejected.
  test('missing config refuses startup', () {
    expect(
      () => AppConfig.validate(flavor: '', apiBaseUrl: '', nativeFlavor: 'dev'),
      throwsStateError,
    );
  });

  test('native flavour must match config', () {
    expect(
      () => AppConfig.validate(
        flavor: 'dev',
        apiBaseUrl: 'http://10.0.2.2:5274/api/v1',
        nativeFlavor: 'prod',
      ),
      throwsStateError,
    );
  });

  test('matching config is accepted', () {
    expect(
      AppConfig.validate(
        flavor: 'dev',
        apiBaseUrl: 'http://10.0.2.2:5274/api/v1',
        nativeFlavor: 'dev',
      ).flavor,
      'dev',
    );
  });

  // Verify that cents are formatted as South African rand without decimals
  // being calculated using floating-point arithmetic.
  for (final (cents, expected) in [
    (10, 'R\u00A00,10'),
    (15050, 'R\u00A0150,50'),
    (150000, 'R\u00A01\u00A0500,00'),
    (100000000, 'R\u00A01\u00A0000\u00A0000,00'),
    (-15050, '-R\u00A0150,50'),
    (0, 'R\u00A00,00'),
  ]) {
    test('formats $cents without floating point', () {
      expect(formatCents(Cents(cents)), expected);
    });
  }

  // Verify that valid rand amounts are converted into whole cents.
  for (final (text, cents) in [
    ('150', 15000),
    ('150,50', 15050),
    ('R150', 15000),
    ('R 1 500', 150000),
    ('1 500,50', 150050),
    ('1\u00A0500,50', 150050),
    ('R\u00A01\u00A0500', 150000),
    ('150.50', 15050),
    ('0,1', 10),
  ]) {
    test('parses $text', () {
      expect((parseRands(text) as ParsedMoney).amount.value, cents);
    });
  }

  // Verify that invalid monetary inputs are rejected with an explanation.
  for (final text in [
    '1,500.50',
    '150,505',
    '150.',
    '',
    'abc',
    '15 00',
    '-1',
  ]) {
    test('rejects "$text" with a reason', () {
      expect(parseRands(text), isA<InvalidMoney>());
      expect((parseRands(text) as InvalidMoney).reason, isNotEmpty);
    });
  }
}
