import 'package:ronditrack_mobile/features/stokvels/domain/models.dart';

abstract interface class StokvelRepository {
  /// Null covers both nonexistent stokvels and stokvels outside the membership.
  Future<StokvelDetail?> fetchDetail(int stokvelId);
}
