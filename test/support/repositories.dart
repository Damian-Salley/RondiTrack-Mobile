import 'package:ronditrack_mobile/features/home/domain/home_entry.dart';
import 'package:ronditrack_mobile/features/home/domain/home_repository.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/models.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/stokvel_repository.dart';

/// Provides custom Home data and counts repository calls during tests.
class TestHomeRepository implements HomeRepository {
  new(this.load);

  final Future<List<HomeEntry>> Function() load;
  int calls = 0;

  @override
  Future<List<HomeEntry>> fetchHome() {
    calls++;
    return load();
  }
}

/// Provides custom stokvel details and counts calls for each stokvel ID.
class TestStokvelRepository implements StokvelRepository {
  new(this.load);

  final Future<StokvelDetail?> Function(int) load;
  final calls = <int, int>{};

  @override
  Future<StokvelDetail?> fetchDetail(int stokvelId) {
    calls.update(stokvelId, (count) => count + 1, ifAbsent: () => 1);
    return load(stokvelId);
  }
}
