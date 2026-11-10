import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/models.dart';
import 'package:ronditrack_mobile/features/stokvels/stokvel_providers.dart';

part 'detail_provider.g.dart';

/// Fetches details for a specific stokvel using its ID.
@riverpod
Future<StokvelDetail?> detail(Ref ref, int stokvelId) {
  // Only an ID is logged: no names, tokens or financial data.
  ref.onDispose(() => debugPrint('Disposed stokvel id=$stokvelId'));

  return ref.watch(stokvelRepositoryProvider).fetchDetail(stokvelId);
}
