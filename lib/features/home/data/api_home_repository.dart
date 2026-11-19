import 'package:ronditrack_mobile/core/data/api_result.dart';
import 'package:ronditrack_mobile/core/data/generated/models/home_stokvel_response.dart';
import 'package:ronditrack_mobile/core/data/generated/rondi_track_client.dart';
import 'package:ronditrack_mobile/core/money.dart';
import 'package:ronditrack_mobile/features/home/domain/home_entry.dart';
import 'package:ronditrack_mobile/features/home/domain/home_repository.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/models.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/status.dart';

class ApiHomeRepository implements HomeRepository {
  const new(this._client);

  final RondiTrackClient _client;

  @override
  Future<List<HomeEntry>> fetchHome() async {
    final result = await apiResult(() async {
      final rows = await _client.me.getApiV1MeHome();
      return rows.map(_mapHome).toList(growable: false);
    });
    return result.unwrap();
  }
}

// Membership belongs to the individual Home row, even across the same user.
HomeEntry _mapHome(HomeStokvelResponse row) => HomeEntry(
  membership: Membership(
    stokvelId: apiInteger(row.stokvelId),
    role: StokvelRole.fromApi(row.role ?? ''),
  ),
  stokvelName: row.stokvelName!,
  paidThisCycle: Cents(apiInteger(row.paidThisCycle)),
  stillOwes: Cents(apiInteger(row.stillOwes)),
  arrears: Cents(apiInteger(row.arrearsCents)),
  totalCollected: Cents(apiInteger(row.totalCollectedCents)),
  currentCycle: row.currentCycle == null ? null : apiInteger(row.currentCycle),
  cycleStatus: switch (row.cycleStatus) {
    final String value => CycleStatus.fromApi(value),
    null => null,
  },
  nextPayoutDate: row.nextPayoutDate?.toUtc(),
);
