import 'package:flutter/foundation.dart';
import 'package:ronditrack_mobile/features/contributions/domain/contribution_page.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/models.dart';

enum PageFailure { first, later }

class ContributionPaging extends ChangeNotifier {
  new(this._fetch, {this.filters = emptyContributionFilters});

  final Future<ContributionPage> Function(ContributionFilters, String?) _fetch;
  ContributionFilters filters;
  List<Contribution> rows = const [];
  PageFailure? failure;
  String? _token;
  Future<void>? _request;
  int _revision = 0;
  bool _reload = false;
  bool _disposed = false;
  bool loading = true;
  bool ended = false;

  Future<void> refresh() => _restart(keepRows: true);

  Future<void> changeFilters(ContributionFilters value) {
    filters = value;
    return _restart(keepRows: false);
  }

  Future<void> _restart({required bool keepRows}) {
    _revision++;
    _reload = true;
    _token = null;
    failure = null;
    ended = false;
    loading = true;
    if (!keepRows) rows = const [];
    notifyListeners();
    return _run(first: true);
  }

  Future<void> next() {
    if (_request != null || ended || failure == PageFailure.first) {
      return Future.value();
    }
    return _run(first: false);
  }

  Future<void> _run({required bool first}) {
    if (_request case final active?) return active;
    final request = _pump(first: first);
    _request = request;
    return request.whenComplete(() => _request = null);
  }

  Future<void> _pump({required bool first}) async {
    var firstPage = first;
    do {
      _reload = false;
      final revision = _revision;
      loading = true;
      failure = null;
      notifyListeners();
      try {
        final page = await _fetch(filters, firstPage ? null : _token);
        if (_disposed) return;
        if (revision == _revision) {
          rows = firstPage ? page.rows : [...rows, ...page.rows];
          _token = page.nextToken;
          ended = _token == null;
        }
      } on Object {
        if (_disposed) return;
        if (revision == _revision) {
          failure = firstPage ? PageFailure.first : PageFailure.later;
        }
      }
      firstPage = true;
    } while (_reload);
    loading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
