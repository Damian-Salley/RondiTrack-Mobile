// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'contribution_response.g.dart';

@JsonSerializable()
class ContributionResponse {
  const ContributionResponse({
    this.userId,
    this.stokvelId,
    this.cycle,
    this.cycleNumber,
    this.amountCents,
    this.status,
    this.paidAtUtc,
    this.memberName,
    this.id,
  });

  factory ContributionResponse.fromJson(Map<String, Object?> json) =>
      _$ContributionResponseFromJson(json);

  final dynamic userId;
  final dynamic stokvelId;
  final dynamic cycle;
  final dynamic cycleNumber;
  final dynamic amountCents;
  final String? status;
  final DateTime? paidAtUtc;
  final String? memberName;
  final String? id;

  Map<String, Object?> toJson() => _$ContributionResponseToJson(this);
}
