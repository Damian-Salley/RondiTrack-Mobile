// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contribution_cycle_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContributionCycleResponse _$ContributionCycleResponseFromJson(
  Map<String, dynamic> json,
) => ContributionCycleResponse(
  id: json['id'],
  stokvelId: json['stokvelId'],
  number: json['number'],
  targetAmount: json['targetAmount'],
  targetAmountCents: json['targetAmountCents'],
  requiredContributionCents: json['requiredContributionCents'],
  status: json['status'] as String?,
  dueDateUtc: json['dueDateUtc'] == null
      ? null
      : DateTime.parse(json['dueDateUtc'] as String),
);

Map<String, dynamic> _$ContributionCycleResponseToJson(
  ContributionCycleResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'stokvelId': instance.stokvelId,
  'number': instance.number,
  'targetAmount': instance.targetAmount,
  'targetAmountCents': instance.targetAmountCents,
  'requiredContributionCents': instance.requiredContributionCents,
  'status': instance.status,
  'dueDateUtc': instance.dueDateUtc?.toIso8601String(),
};
