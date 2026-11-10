import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_mobile/core/view_state.dart';
import 'package:ronditrack_mobile/features/home/data/fake_home_repository.dart';
import 'package:ronditrack_mobile/features/session/domain/persona.dart';
import 'package:ronditrack_mobile/features/stokvels/data/fake_stokvel_repository.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/actions.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/status.dart';

void main() {
  test('exact cycle strings and unknown forward compatibility', () {
    expect(CycleStatus.fromApi('Active'), CycleStatus.active);
    expect(CycleStatus.fromApi('Closed'), CycleStatus.closed);
    expect(CycleStatus.fromApi('Paid'), CycleStatus.paid);
    expect(CycleStatus.fromApi('Open'), CycleStatus.unknown);
    expect(CycleStatus.fromApi('active'), CycleStatus.unknown);
  });

  test('exact contribution strings and unknown forward compatibility', () {
    expect(ContributionStatus.fromApi('Pending'), ContributionStatus.pending);
    expect(ContributionStatus.fromApi('Paid'), ContributionStatus.paid);
    expect(
      ContributionStatus.fromApi('Confirmed'),
      ContributionStatus.confirmed,
    );
    expect(ContributionStatus.fromApi('Refunded'), ContributionStatus.unknown);
  });

  test('exact role strings and unknown forward compatibility', () {
    expect(StokvelRole.fromApi('Member'), StokvelRole.member);
    expect(StokvelRole.fromApi('Treasurer'), StokvelRole.treasurer);
    expect(StokvelRole.fromApi('Chairperson'), StokvelRole.chairperson);
    expect(StokvelRole.fromApi('Admin'), StokvelRole.unknown);
  });

  test('every status has a word label', () {
    for (final status in CycleStatus.values) {
      expect(status.label, isNotEmpty);
    }

    for (final status in ContributionStatus.values) {
      expect(status.label, isNotEmpty);
    }

    for (final role in StokvelRole.values) {
      expect(role.label, isNotEmpty);
    }
  });

  test('same persona has a different role in each membership', () async {
    final entries = await const FakeHomeRepository(
      Persona.demo,
      delay: Duration.zero,
    ).fetchHome();

    expect(entries[0].membership.role, StokvelRole.treasurer);
    expect(entries[1].membership.role, StokvelRole.member);
    expect(
      entries[0].membership.stokvelId,
      isNot(entries[1].membership.stokvelId),
    );
  });

  test(
    'third persona is empty and inaccessible is indistinguishable',
    () async {
      expect(
        await const FakeHomeRepository(
          Persona.newcomer,
          delay: Duration.zero,
        ).fetchHome(),
        isEmpty,
      );

      const repo = FakeStokvelRepository(
        Persona.newcomer,
        delay: Duration.zero,
      );

      expect(await repo.fetchDetail(1), isNull);
      expect(await repo.fetchDetail(999), isNull);
    },
  );

  // Test the actions allowed for different roles and statuses.
  final rows =
      <
        (
          String,
          (StokvelRole, CycleStatus, ContributionStatus?),
          Set<StokvelAction>,
        )
      >[
        ('unknown role', (.unknown, .active, .paid), {}),
        ('closed', (.treasurer, .closed, .paid), {}),
        ('paid cycle', (.treasurer, .paid, .paid), {}),
        ('unknown cycle', (.treasurer, .unknown, .paid), {}),
        ('unknown contribution', (.treasurer, .active, .unknown), {}),
        ('member no contribution', (.member, .active, null), {.pay}),
        ('member pending', (.member, .active, .pending), {.uploadProof}),
        ('member paid', (.member, .active, .paid), {.uploadProof}),
        ('member confirmed', (.member, .active, .confirmed), {.uploadProof}),
        (
          'treasurer no contribution',
          (.treasurer, .active, null),
          {.pay, .confirmContributions, .closeCycle, .recordPayout},
        ),
        (
          'treasurer existing contribution',
          (.treasurer, .active, .paid),
          {.uploadProof, .confirmContributions, .closeCycle, .recordPayout},
        ),
        (
          'chairperson no contribution',
          (.chairperson, .active, null),
          {.pay, .recordPayout},
        ),
        (
          'chairperson existing contribution',
          (.chairperson, .active, .paid),
          {.uploadProof, .recordPayout},
        ),
      ];

  for (final (name, input, expected) in rows) {
    test('action rule: $name', () {
      expect(allowedActions(input, hasPaidContributions: true), expected);
    });
  }

  // Closed, paid, and unknown cycles must not allow actions.
  test('all inactive combinations suppress actions', () {
    for (final role in StokvelRole.values) {
      for (final cycle in [
        CycleStatus.closed,
        CycleStatus.paid,
        CycleStatus.unknown,
      ]) {
        for (final contribution in [null, ...ContributionStatus.values]) {
          expect(
            allowedActions((
              role,
              cycle,
              contribution,
            ), hasPaidContributions: true),
            isEmpty,
          );
        }
      }
    }
  });

  test('treasurer cannot confirm when no paid contribution exists', () {
    expect(
      allowedActions((
        .treasurer,
        .active,
        .confirmed,
      ), hasPaidContributions: false),
      {
        StokvelAction.uploadProof,
        StokvelAction.closeCycle,
        StokvelAction.recordPayout,
      },
    );
  });

  test('treasurer can confirm another member without an own contribution', () {
    expect(
      allowedActions((.treasurer, .active, null), hasPaidContributions: true),
      {
        StokvelAction.pay,
        StokvelAction.confirmContributions,
        StokvelAction.closeCycle,
        StokvelAction.recordPayout,
      },
    );
  });

  // Verify that Riverpod results become the correct UI states.
  ViewState<List<int>> view(AsyncValue<List<int>> value) =>
      toViewState(value, isEmpty: (items) => items.isEmpty);

  test('view conversion has loading, empty, data and failure', () {
    expect(view(const AsyncLoading()), isA<Loading<List<int>>>());
    expect(view(const AsyncData([])), isA<Empty<List<int>>>());
    expect(view(const AsyncData([1])), isA<Data<List<int>>>());
    expect(
      view(AsyncError(Exception('offline'), StackTrace.current)),
      isA<Failure<List<int>>>(),
    );
  });
}
