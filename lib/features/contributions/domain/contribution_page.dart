import 'package:ronditrack_mobile/core/south_african_day.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/models.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/status.dart';

typedef ContributionPage = ({List<Contribution> rows, String? nextToken});

typedef ContributionFilters = ({
  int? cycleId,
  ContributionStatus? status,
  int? memberId,
  SouthAfricanDay? from,
  SouthAfricanDay? to,
});

const ContributionFilters emptyContributionFilters = (
  cycleId: null,
  status: null,
  memberId: null,
  from: null,
  to: null,
);

typedef FilterOptions = ({
  List<({int id, int number})> cycles,
  List<({int id, String name})> members,
});
