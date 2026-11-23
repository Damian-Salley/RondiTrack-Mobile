import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Successful writes prompt the home view and the affected stokvel views to
/// refresh their server-owned totals.
final offlineRefreshProvider = Provider<StreamController<int?>>((ref) {
  final events = StreamController<int?>.broadcast();
  ref.onDispose(events.close);
  return events;
});
