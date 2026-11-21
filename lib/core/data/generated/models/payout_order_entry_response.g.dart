// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payout_order_entry_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayoutOrderEntryResponse _$PayoutOrderEntryResponseFromJson(
  Map<String, dynamic> json,
) => PayoutOrderEntryResponse(
  userId: json['userId'],
  memberName: json['memberName'] as String,
  position: json['position'],
  amountCents: json['amountCents'],
  paidAtUtc: json['paidAtUtc'] == null
      ? null
      : DateTime.parse(json['paidAtUtc'] as String),
  status: json['status'] as String,
);

Map<String, dynamic> _$PayoutOrderEntryResponseToJson(
  PayoutOrderEntryResponse instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'memberName': instance.memberName,
  'position': instance.position,
  'amountCents': instance.amountCents,
  'paidAtUtc': instance.paidAtUtc?.toIso8601String(),
  'status': instance.status,
};
