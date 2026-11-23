import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_mobile/core/api_failure.dart';
import 'package:ronditrack_mobile/core/money.dart';
import 'package:ronditrack_mobile/features/contributions/contribution_providers.dart';
import 'package:ronditrack_mobile/features/contributions/domain/payment_intent.dart';
import 'package:ronditrack_mobile/features/contributions/presentation/payment_notice_text.dart';
import 'package:ronditrack_mobile/l10n/localization.dart';

class PayForm extends ConsumerStatefulWidget {
  const new({required this.target, required this.suggestedAmount, super.key});

  final PaymentTarget target;
  final Cents suggestedAmount;

  @override
  ConsumerState<PayForm> createState() => _PayFormState();
}

class _PayFormState extends ConsumerState<PayForm> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _amount;
  bool _submitting = false;
  bool _storageFailure = false;
  String? _dismissedNotice;

  @override
  void initState() {
    super.initState();
    _amount = TextEditingController(text: randDecimal(widget.suggestedAmount));
  }

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  Future<void> _submit({required bool retry}) async {
    if (_submitting || (!retry && !_form.currentState!.validate())) return;
    setState(() {
      _submitting = true;
      _storageFailure = false;
    });
    try {
      final outbox = ref.read(paymentOutboxSyncProvider);
      if (retry) {
        await outbox.flush();
      } else {
        final amount = (parseRands(_amount.text) as ParsedMoney).amount;
        await outbox.enqueue(widget.target, amount);
      }
    } on Object {
      if (mounted) setState(() => _storageFailure = true);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final queue = ref.watch(pendingPaymentsProvider);
    final pending = queue.value
        ?.where((payment) => payment.target == widget.target)
        .firstOrNull;
    final notice = ref.watch(paymentNoticeProvider).value;
    final result =
        notice?.payment.target == widget.target &&
            notice?.payment.key != _dismissedNotice
        ? notice
        : null;
    final paid = result?.disposition == PaymentDisposition.paid;
    final fields = switch (result?.failure) {
      ValidationFailure(:final fields) => fields,
      _ => const <String, List<String>>{},
    };
    final retryAt = pending?.retryAt;
    final rateLimited = retryAt != null && retryAt.isAfter(DateTime.now());

    return Scaffold(
      appBar: AppBar(title: Text(strings.payContribution)),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _amount,
              readOnly: pending != null || _submitting || paid,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(labelText: strings.amount),
              forceErrorText: fields['amountInCents']?.join('\n'),
              onChanged: (_) {
                if (result != null) {
                  setState(() => _dismissedNotice = result.payment.key);
                }
              },
              errorBuilder: (context, error) =>
                  Semantics(liveRegion: true, child: Text(error)),
              validator: (text) => isContributionAmount(parseRands(text!))
                  ? null
                  : strings.invalidAmount,
            ),
            if (fields['userId'] case final errors?)
              Semantics(
                liveRegion: true,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: strings.member,
                    errorText: errors.join('\n'),
                  ),
                  child: Text('${widget.target.userId}'),
                ),
              ),
            const SizedBox(height: 16),
            if (pending != null) ...[
              Semantics(
                liveRegion: true,
                child: Text(strings.pendingAmount(formatCents(pending.amount))),
              ),
              if (rateLimited)
                Text(strings.waiting(context.formatTime(retryAt))),
              OutlinedButton(
                onPressed: _submitting || rateLimited
                    ? null
                    : () => _submit(retry: true),
                child: Text(strings.tryAgain),
              ),
            ],
            if (result != null && pending == null)
              Semantics(
                liveRegion: true,
                child: Text(paymentNoticeText(strings, result)),
              ),
            if (_storageFailure || queue.hasError)
              Semantics(liveRegion: true, child: Text(strings.saveFailed)),
            FilledButton(
              onPressed:
                  pending != null ||
                      _submitting ||
                      paid ||
                      queue.isLoading ||
                      queue.hasError
                  ? null
                  : () => _submit(retry: false),
              child: Text(strings.pay),
            ),
          ],
        ),
      ),
    );
  }
}
