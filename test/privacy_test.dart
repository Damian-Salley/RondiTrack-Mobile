import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_mobile/core/telemetry/error_reporter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() {
  test('realistic event exposes only safe information and the API trace', () {
    const trace = '4bf92f3577b34da6a3ce929d0e0e4736';
    const secrets = [
      'Thandi Nkosi',
      'thandi@example.invalid',
      'R 1 250,50',
      'R\u00a01\u00a0250,50',
      'Bearer fake.token.value',
      'Thandi_proof_Nov.jpg',
    ];
    final payload = secrets.join(' | ');
    final url = 'https://fixture.invalid/pay?q=${Uri.encodeComponent(payload)}';
    final event = SentryEvent(
      message: SentryMessage(payload),
      exceptions: [SentryException(type: 'PaymentError', value: payload)],
      breadcrumbs: [
        Breadcrumb(
          message: '$payload $url',
          data: {'url': url, 'raw': payload},
        ),
      ],
      tags: {correlationTag: trace, 'comment': payload},
      user: SentryUser(username: payload, email: secrets[1]),
      request: SentryRequest(
        url: url,
        data: payload,
        headers: {'Secret': payload},
      ),
    );
    final scrubbed = scrubEvent(event, memberName: secrets.first);
    final json = jsonEncode(scrubbed.toJson());
    for (final secret in secrets) {
      expect(json, isNot(contains(secret)), reason: 'Leaked $secret');
      expect(json, isNot(contains(Uri.encodeComponent(secret))));
    }
    expect(json, isNot(contains('fixture.invalid')));
    expect(scrubbed.tags, {correlationTag: trace});
  });
}
