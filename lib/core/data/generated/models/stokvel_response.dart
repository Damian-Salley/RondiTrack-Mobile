// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'stokvel_response.g.dart';

@JsonSerializable()
class StokvelResponse {
  const StokvelResponse({
    this.id,
    this.name,
    this.contributionAmount,
    this.contributionAmountCents,
    this.memberCount,
  });

  factory StokvelResponse.fromJson(Map<String, Object?> json) =>
      _$StokvelResponseFromJson(json);

  final dynamic id;
  final String? name;
  final dynamic contributionAmount;
  final dynamic contributionAmountCents;
  final dynamic memberCount;

  Map<String, Object?> toJson() => _$StokvelResponseToJson(this);
}
