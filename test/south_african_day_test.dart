import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_mobile/core/south_african_day.dart';

void main() {
  test('00:30 SAST belongs to November 1 in any device time zone', () {
    const day = SouthAfricanDay(2026, 11, 1);
    final contribution = DateTime.utc(2026, 10, 31, 22, 30);

    expect(day.startUtc, DateTime.utc(2026, 10, 31, 22));
    expect(day.endUtcExclusive, DateTime.utc(2026, 11, 1, 22));
    expect(day.contains(contribution.toLocal()), isTrue);
    expect(SouthAfricanDay.fromInstant(contribution.toLocal()).day, 1);
    expect(day.contains(day.startUtc), isTrue);
    expect(day.contains(day.endUtcExclusive), isFalse);
  });
}
