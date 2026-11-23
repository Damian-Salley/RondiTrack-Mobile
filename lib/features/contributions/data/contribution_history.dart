import 'package:ronditrack_mobile/core/data/api_client.dart';
import 'package:ronditrack_mobile/core/data/api_result.dart';
import 'package:ronditrack_mobile/core/data/map_api_failure.dart';
import 'package:ronditrack_mobile/features/contributions/domain/contribution_page.dart';
import 'package:ronditrack_mobile/features/stokvels/data/api_stokvel_repository.dart';

class ContributionHistory {
  const new(this._api);

  final ApiClient _api;

  Future<ContributionPage> fetch(
    int stokvelId,
    ContributionFilters filters,
    String? token,
  ) async {
    try {
      final page = await _api.rest.stokvels
          .getApiV1StokvelsStokvelIdContributions(
            stokvelId: stokvelId,
            pageSize: 20,
            pageToken: token,
            cycleId: filters.cycleId,
            status: switch (filters.status) {
              .paid => 'Paid',
              .pending => 'Pending',
              .confirmed => 'Confirmed',
              _ => null,
            },
            userId: filters.memberId,
            from: filters.from?.startUtc,
            to: filters.to?.endUtcExclusive,
          );
      return (
        rows: (page.items ?? []).map(mapContribution).toList(growable: false),
        nextToken: page.nextPageToken,
      );
    } on Object catch (error) {
      throw mapApiFailure(error);
    }
  }

  Future<FilterOptions> options(int stokvelId) async {
    final (cycles, members) = await (
      _api.rest.contributionCycles.getApiV1Contributioncycles(),
      _api.stokvelMembers(stokvelId),
    ).wait;
    return (
      cycles: [
        for (final cycle in cycles)
          if (apiInteger(cycle.stokvelId) == stokvelId)
            (id: apiInteger(cycle.id), number: apiInteger(cycle.number)),
      ],
      members: members,
    );
  }
}
