// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'contribution_cycle_response.g.dart';

@JsonSerializable()
class ContributionCycleResponse {
  const ContributionCycleResponse({
    this.id,
    this.stokvelId,
    this.number,
    this.targetAmount,
    this.targetAmountCents,
    this.requiredContributionCents,
    this.status,
    this.dueDateUtc,
  });

  factory ContributionCycleResponse.fromJson(Map<String, Object?> json) =>
      _$ContributionCycleResponseFromJson(json);

  final dynamic id;
  final dynamic stokvelId;
  final dynamic number;
  final dynamic targetAmount;
  final dynamic targetAmountCents;
  final dynamic requiredContributionCents;
  final String? status;
  final DateTime? dueDateUtc;

  Map<String, Object?> toJson() => _$ContributionCycleResponseToJson(this);
}
