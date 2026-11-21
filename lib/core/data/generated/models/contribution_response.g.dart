// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contribution_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContributionResponse _$ContributionResponseFromJson(
  Map<String, dynamic> json,
) => ContributionResponse(
  userId: json['userId'],
  stokvelId: json['stokvelId'],
  cycle: json['cycle'],
  cycleNumber: json['cycleNumber'],
  amountCents: json['amountCents'],
  status: json['status'] as String?,
  paidAtUtc: json['paidAtUtc'] == null
      ? null
      : DateTime.parse(json['paidAtUtc'] as String),
  memberName: json['memberName'] as String?,
  id: json['id'] as String?,
);

Map<String, dynamic> _$ContributionResponseToJson(
  ContributionResponse instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'stokvelId': instance.stokvelId,
  'cycle': instance.cycle,
  'cycleNumber': instance.cycleNumber,
  'amountCents': instance.amountCents,
  'status': instance.status,
  'paidAtUtc': instance.paidAtUtc?.toIso8601String(),
  'memberName': instance.memberName,
  'id': instance.id,
};
