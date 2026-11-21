// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'record_cycle_contribution_request.g.dart';

@JsonSerializable()
class RecordCycleContributionRequest {
  const RecordCycleContributionRequest({this.userId, this.amountInCents});

  factory RecordCycleContributionRequest.fromJson(Map<String, Object?> json) =>
      _$RecordCycleContributionRequestFromJson(json);

  final dynamic userId;
  final dynamic amountInCents;

  Map<String, Object?> toJson() => _$RecordCycleContributionRequestToJson(this);
}
