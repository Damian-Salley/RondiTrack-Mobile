/// Represents money as whole cents to avoid floating-point rounding errors.
extension type const Cents(int value);

/// Converts cents into South African currency format.
String formatCents(Cents amount) {
  final absolute = amount.value.abs();
  final rands = (absolute ~/ 100).toString();
  final grouped = StringBuffer();

  // Separate thousands using non-breaking spaces.
  for (var i = 0; i < rands.length; i++) {
    if (i > 0 && (rands.length - i) % 3 == 0) {
      grouped.write('\u00A0');
    }
    grouped.write(rands[i]);
  }

  // Always display exactly two decimal digits.
  final cents = (absolute % 100).toString().padLeft(2, '0');

  return '${amount.value < 0 ? '-' : ''}R\u00A0$grouped,$cents';
}

/// Represents the result of attempting to parse a money amount.
sealed class MoneyParseResult {
  const new();
}

/// Returned when the entered amount is valid.
final class ParsedMoney extends MoneyParseResult {
  const new(this.amount);

  final Cents amount;
}

/// Returned when the entered amount is invalid.
final class InvalidMoney extends MoneyParseResult {
  const new(this.reason);

  final String reason;
}

/// Converts a rand amount into cents.
/// Full stops and commas are accepted as decimal separators.
MoneyParseResult parseRands(String input) {
  // Remove surrounding spaces and an optional rand symbol.
  final text = input.trim().replaceFirst(RegExp(r'^R\s*'), '');

  // Allow whole rands and up to two decimal digits.
  const pattern = r'^(\d+|\d{1,3}(?:[ \u00A0]\d{3})+)(?:[,.](\d{1,2}))?$';

  final match = RegExp(pattern).firstMatch(text);

  if (match == null) {
    return const InvalidMoney('Enter rands with at most two decimal digits.');
  }

  // Remove thousands separators before converting the amount.
  final whole = match[1]!.replaceAll(RegExp('[ \u00A0]'), '');
  final fraction = (match[2] ?? '').padRight(2, '0');

  // Use integer arithmetic to avoid rounding errors.
  final cents = BigInt.parse(whole) * BigInt.from(100) + BigInt.parse(fraction);

  // Reject amounts that exceed the supported 64-bit cents range.
  if (cents > BigInt.from(9223372036854775807)) {
    return const InvalidMoney('Amount is too large.');
  }

  return ParsedMoney(Cents(cents.toInt()));
}
