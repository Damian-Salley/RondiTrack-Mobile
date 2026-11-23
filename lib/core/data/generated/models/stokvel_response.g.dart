// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stokvel_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StokvelResponse _$StokvelResponseFromJson(Map<String, dynamic> json) =>
    StokvelResponse(
      id: json['id'],
      version: json['version'] as String?,
      name: json['name'] as String?,
      contributionAmount: json['contributionAmount'],
      contributionAmountCents: json['contributionAmountCents'],
      memberCount: json['memberCount'],
    );

Map<String, dynamic> _$StokvelResponseToJson(StokvelResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'version': instance.version,
      'name': instance.name,
      'contributionAmount': instance.contributionAmount,
      'contributionAmountCents': instance.contributionAmountCents,
      'memberCount': instance.memberCount,
    };
