import 'package:ronditrack_mobile/core/api_failure.dart';
import 'package:ronditrack_mobile/features/contributions/domain/payment_intent.dart';
import 'package:ronditrack_mobile/l10n/localization.dart';

String paymentNoticeText(AppLocalizations strings, PaymentNotice notice) =>
    switch (notice.disposition) {
      .paid => strings.paidPayment,
      .expired => strings.expiredPayment,
      .refused => switch (notice.failure) {
        ConflictFailure(title: 'Duplicate contribution') =>
          strings.duplicatePayment,
        NotFoundFailure() || ForbiddenFailure() => strings.paymentMembership,
        RuleFailure() => strings.paymentClosed,
        _ => strings.refusedPayment,
      },
    };
