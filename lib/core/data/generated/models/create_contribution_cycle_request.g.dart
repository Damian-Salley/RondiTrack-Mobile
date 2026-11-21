// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_contribution_cycle_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateContributionCycleRequest _$CreateContributionCycleRequestFromJson(
  Map<String, dynamic> json,
) => CreateContributionCycleRequest(
  id: json['id'],
  stokvelId: json['stokvelId'],
  number: json['number'],
  targetAmount: json['targetAmount'],
);

Map<String, dynamic> _$CreateContributionCycleRequestToJson(
  CreateContributionCycleRequest instance,
) => <String, dynamic>{
  'id': instance.id,
  'stokvelId': instance.stokvelId,
  'number': instance.number,
  'targetAmount': instance.targetAmount,
};
