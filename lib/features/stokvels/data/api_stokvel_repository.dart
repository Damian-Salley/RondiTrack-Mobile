import 'package:ronditrack_mobile/core/api_failure.dart';
import 'package:ronditrack_mobile/core/data/api_client.dart';
import 'package:ronditrack_mobile/core/data/api_result.dart';
import 'package:ronditrack_mobile/core/data/generated/models/contribution_response.dart';
import 'package:ronditrack_mobile/core/money.dart';
import 'package:ronditrack_mobile/core/result.dart';
import 'package:ronditrack_mobile/features/home/domain/home_repository.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/close_preview.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/models.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/status.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/stokvel_repository.dart';

class ApiStokvelRepository implements StokvelRepository {
  const new(this._client, this._home);

  final ApiClient _client;
  final HomeRepository _home;

  Future<CycleClosePreview> previewClose(int stokvelId, int cycleId) async =>
      (await readClosePreview(stokvelId, cycleId)).unwrap();

  Future<Result<CycleClosePreview>> readClosePreview(
    int stokvelId,
    int cycleId,
  ) => apiResult(() async {
    final cycles = await _client.rest.contributionCycles
        .getApiV1Contributioncycles();
    if (!cycles.any(
      (row) =>
          apiInteger(row.id) == cycleId &&
          apiInteger(row.stokvelId) == stokvelId,
    )) {
      throw const NotFoundFailure();
    }
    final preview = await _client.rest.joinPaymentClosing
        .getApiV1ContributioncyclesCycleIdClosePreview(cycleId: cycleId);
    return (
      version: preview.version,
      date: preview.asOfDate,
      total: Cents(apiInteger(preview.totalCents)),
    );
  });

  @override
  Future<StokvelDetail?> fetchDetail(int stokvelId, {int? cycleId}) async =>
      (await readDetail(stokvelId, cycleId: cycleId)).unwrap();

  /// Resolves access and returns a domain detail or a typed failure.
  Future<Result<StokvelDetail>> readDetail(int stokvelId, {int? cycleId}) =>
      apiResult(() async {
        // Resolve access before starting any dependent requests.
        final stokvel = await _client.rest.stokvels.getApiV1StokvelsId(
          id: stokvelId,
        );
        final (home, identity, cycles) = await (
          _home.fetchHome(),
          _client.rest.me.getApiV1Me(),
          _client.rest.contributionCycles.getApiV1Contributioncycles(),
        ).wait;
        final entry = home
            .where((item) => item.membership.stokvelId == stokvelId)
            .firstOrNull;
        if (entry == null) throw const NotFoundFailure();
        final current = cycles.where((row) {
          if (apiInteger(row.stokvelId) != stokvelId) return false;
          // Cycle links use IDs. Stokvel detail defaults to the active cycle.
          return cycleId != null
              ? apiInteger(row.id) == cycleId
              : apiInteger(row.number) == entry.currentCycle;
        }).firstOrNull;
        if (cycleId != null && current == null) throw const NotFoundFailure();
        final cycle = current == null
            ? null
            : Cycle(
                id: apiInteger(current.id),
                stokvelId: stokvelId,
                number: apiInteger(current.number),
                status: CycleStatus.fromApi(current.status ?? ''),
                dueDateUtc: current.dueDateUtc!.toUtc(),
                targetAmount: Cents(apiInteger(current.targetAmountCents)),
                requiredContribution: Cents(
                  apiInteger(current.requiredContributionCents),
                ),
              );
        final contributions = <Contribution>[];
        if (cycle != null) {
          String? token;
          do {
            final page = await _client.rest.stokvels
                .getApiV1StokvelsStokvelIdCyclesCycleIdContributions(
                  stokvelId: stokvelId,
                  cycleId: cycle.id,
                  pageToken: token,
                );
            contributions.addAll((page.items ?? []).map(mapContribution));
            token = page.nextPageToken;
          } while (token != null);
        }
        return StokvelDetail(
          stokvel: Stokvel(
            id: stokvelId,
            name: stokvel.name!,
            contributionAmount: Cents(
              apiInteger(stokvel.contributionAmountCents),
            ),
            memberCount: apiInteger(stokvel.memberCount),
          ),
          membership: entry.membership,
          callerId: apiInteger(identity.id),
          currentCycle: cycle,
          contributions: contributions,
        );
      });
}

Contribution mapContribution(ContributionResponse row) => Contribution(
  userId: apiInteger(row.userId),
  stokvelId: apiInteger(row.stokvelId),
  cycleId: apiInteger(row.cycle),
  memberName: row.memberName!,
  amount: Cents(apiInteger(row.amountCents)),
  status: ContributionStatus.fromApi(row.status ?? ''),
  paidAtUtc: row.paidAtUtc?.toUtc(),
);

Future<List<Contribution>> fetchApiActivity(ApiClient client) async {
  final result = await apiResult(() async {
    final page = await client.rest.me.getApiV1MeActivity();
    return (page.items ?? []).map(mapContribution).toList();
  });
  return result.unwrap();
}
