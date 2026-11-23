import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_mobile/core/api_failure.dart';
import 'package:ronditrack_mobile/core/data/api_client.dart';
import 'package:ronditrack_mobile/core/money.dart';
import 'package:ronditrack_mobile/core/offline_refresh.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/models.dart';
import 'package:ronditrack_mobile/features/stokvels/stokvel_providers.dart';
import 'package:ronditrack_mobile/l10n/localization.dart';

class StokvelForm extends ConsumerStatefulWidget {
  const new({this.initial, super.key});

  final Stokvel? initial;

  @override
  ConsumerState<StokvelForm> createState() => _StokvelFormState();
}

class _StokvelFormState extends ConsumerState<StokvelForm> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _amount;
  late final TextEditingController _id;
  late String? _version;
  Map<String, List<String>> _fields = const {};
  ApiFailure? _failure;
  Stokvel? _latest;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _name = TextEditingController(text: initial?.name);
    _amount = TextEditingController(
      text: initial == null ? '' : formatCents(initial.contributionAmount),
    );
    _id = TextEditingController(text: initial?.id.toString());
    _version = initial?.version;
  }

  @override
  void dispose() {
    _name.dispose();
    _amount.dispose();
    _id.dispose();
    super.dispose();
  }

  void _clear(String field) {
    if (_fields.containsKey(field)) {
      setState(() => _fields = {..._fields}..remove(field));
    }
  }

  int? _readId() {
    final value = int.tryParse(_id.text.trim());
    return value != null && value > 0 && value <= 2147483647 ? value : null;
  }

  Future<void> _submit() async {
    if (_saving || !_form.currentState!.validate()) return;
    final id = _readId()!;
    final amount = (parseRands(_amount.text) as ParsedMoney).amount;
    final edit = widget.initial != null;
    final client = ref.read(apiClientProvider);
    final repository = ref.read(stokvelRepositoryProvider);
    final refresh = ref.read(offlineRefreshProvider);
    setState(() {
      _saving = true;
      _failure = null;
      _fields = const {};
    });
    try {
      await client.saveStokvel(
        id: id,
        name: _name.text.trim(),
        amount: amount,
        version: edit ? _version! : null,
      );
      refresh.add(id);
      if (mounted) Navigator.pop(context, true);
    } on ApiFailure catch (error) {
      if (!mounted) return;
      setState(() {
        _failure = error;
        if (error is ValidationFailure) _fields = error.fields;
      });
      if (edit && error is ConflictFailure) {
        try {
          final latest = await repository.fetchDetail(id);
          if (!mounted || latest == null) return;
          setState(() {
            _latest = latest.stokvel;
            _version = latest.stokvel.version;
          });
          refresh.add(id);
        } on ApiFailure {
          // Preserve the version and the draft until a fresh read succeeds.
        }
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final creating = widget.initial == null;
    return Scaffold(
      appBar: AppBar(
        title: Text(creating ? strings.createStokvel : strings.editStokvel),
      ),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            if (creating)
              TextFormField(
                controller: _id,
                enabled: !_saving,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: strings.stokvelId),
                forceErrorText: _fields['id']?.join('\n'),
                onChanged: (_) => _clear('id'),
                validator: (_) => _readId() == null ? strings.idRequired : null,
              ),
            TextFormField(
              controller: _name,
              enabled: !_saving,
              decoration: InputDecoration(labelText: strings.stokvelName),
              forceErrorText: _fields['name']?.join('\n'),
              onChanged: (_) => _clear('name'),
              validator: (text) =>
                  text!.trim().isEmpty ? strings.nameRequired : null,
            ),
            TextFormField(
              controller: _amount,
              enabled: !_saving,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(labelText: strings.amount),
              forceErrorText: _fields['contributionAmount']?.join('\n'),
              onChanged: (_) => _clear('contributionAmount'),
              validator: (text) => isContributionAmount(parseRands(text!))
                  ? null
                  : strings.invalidAmount,
            ),
            if (_failure != null)
              Semantics(
                liveRegion: true,
                child: Text(
                  _failure is ConflictFailure && !creating
                      ? strings.staleStokvel
                      : strings.saveFailed,
                ),
              ),
            if (_latest case final latest?)
              Text(
                strings.latestStokvel(
                  latest.name,
                  formatCents(latest.contributionAmount),
                ),
              ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _saving || (!creating && _version == null)
                  ? null
                  : _submit,
              child: Text(strings.save),
            ),
          ],
        ),
      ),
    );
  }
}
