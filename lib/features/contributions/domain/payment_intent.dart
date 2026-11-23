import 'package:ronditrack_mobile/core/api_failure.dart';
import 'package:ronditrack_mobile/core/money.dart';

typedef PaymentTarget = ({int stokvelId, int cycleId, int userId});

class PaymentIntent {
  const new({
    required this.key,
    required this.target,
    required this.amount,
    required this.createdAt,
    this.retryAt,
  });

  final String key;
  final PaymentTarget target;
  final Cents amount;
  final DateTime createdAt;
  final DateTime? retryAt;
}

enum PaymentDisposition { paid, refused, expired }

typedef PaymentNotice = ({
  PaymentIntent payment,
  PaymentDisposition disposition,
  ApiFailure? failure,
});
