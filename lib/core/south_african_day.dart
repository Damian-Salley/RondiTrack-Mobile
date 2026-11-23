/// A calendar day in South Africa, which uses UTC+02:00 year-round.
final class SouthAfricanDay {
  const new(this.year, this.month, this.day);

  factory fromInstant(DateTime instant) {
    final date = clockAt(instant);
    return SouthAfricanDay(date.year, date.month, date.day);
  }

  static const _offset = Duration(hours: 2);

  /// Reads the South African wall-clock fields without the device time zone.
  static DateTime clockAt(DateTime instant) => instant.toUtc().add(_offset);

  final int year;
  final int month;
  final int day;

  DateTime get startUtc => DateTime.utc(year, month, day).subtract(_offset);

  DateTime get endUtcExclusive => startUtc.add(const Duration(days: 1));

  bool contains(DateTime instant) =>
      !instant.isBefore(startUtc) && instant.isBefore(endUtcExclusive);
}
