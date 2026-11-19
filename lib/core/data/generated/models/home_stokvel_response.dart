// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'home_stokvel_response.g.dart';

@JsonSerializable()
class HomeStokvelResponse {
  const HomeStokvelResponse({
    this.stokvelId,
    this.stokvelName,
    this.role,
    this.currentCycle,
    this.cycleStatus,
    this.paidThisCycle,
    this.totalCollectedCents,
    this.stillOwes,
    this.arrearsCents,
    this.nextPayoutDate,
  });

  factory HomeStokvelResponse.fromJson(Map<String, Object?> json) =>
      _$HomeStokvelResponseFromJson(json);

  final dynamic stokvelId;
  final String? stokvelName;
  final String? role;
  final dynamic currentCycle;
  final String? cycleStatus;
  final dynamic paidThisCycle;
  final dynamic totalCollectedCents;
  final dynamic stillOwes;
  final dynamic arrearsCents;
  final DateTime? nextPayoutDate;

  Map<String, Object?> toJson() => _$HomeStokvelResponseToJson(this);
}
