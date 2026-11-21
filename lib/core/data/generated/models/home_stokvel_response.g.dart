// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_stokvel_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeStokvelResponse _$HomeStokvelResponseFromJson(Map<String, dynamic> json) =>
    HomeStokvelResponse(
      stokvelId: json['stokvelId'],
      stokvelName: json['stokvelName'] as String?,
      role: json['role'] as String?,
      currentCycle: json['currentCycle'],
      cycleStatus: json['cycleStatus'] as String?,
      paidThisCycle: json['paidThisCycle'],
      totalCollectedCents: json['totalCollectedCents'],
      stillOwes: json['stillOwes'],
      arrearsCents: json['arrearsCents'],
      nextPayoutDate: json['nextPayoutDate'] == null
          ? null
          : DateTime.parse(json['nextPayoutDate'] as String),
    );

Map<String, dynamic> _$HomeStokvelResponseToJson(
  HomeStokvelResponse instance,
) => <String, dynamic>{
  'stokvelId': instance.stokvelId,
  'stokvelName': instance.stokvelName,
  'role': instance.role,
  'currentCycle': instance.currentCycle,
  'cycleStatus': instance.cycleStatus,
  'paidThisCycle': instance.paidThisCycle,
  'totalCollectedCents': instance.totalCollectedCents,
  'stillOwes': instance.stillOwes,
  'arrearsCents': instance.arrearsCents,
  'nextPayoutDate': instance.nextPayoutDate?.toIso8601String(),
};
