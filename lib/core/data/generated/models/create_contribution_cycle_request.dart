// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'create_contribution_cycle_request.g.dart';

@JsonSerializable()
class CreateContributionCycleRequest {
  const CreateContributionCycleRequest({
    this.id,
    this.stokvelId,
    this.number,
    this.targetAmount,
  });

  factory CreateContributionCycleRequest.fromJson(Map<String, Object?> json) =>
      _$CreateContributionCycleRequestFromJson(json);

  final dynamic id;
  final dynamic stokvelId;
  final dynamic number;
  final dynamic targetAmount;

  Map<String, Object?> toJson() => _$CreateContributionCycleRequestToJson(this);
}
