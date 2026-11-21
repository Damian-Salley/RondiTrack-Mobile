import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tests can select all fakes with one provider override.
final useApiProvider = Provider<bool>((ref) => false);
