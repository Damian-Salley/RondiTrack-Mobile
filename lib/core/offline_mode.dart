import 'package:flutter_riverpod/flutter_riverpod.dart';

// Only the application bootstrap opts into persistent platform storage. Tests
// that exercise offline mode can opt in with an in-memory database instead.
final offlineStorageEnabledProvider = Provider<bool>((ref) => false);
