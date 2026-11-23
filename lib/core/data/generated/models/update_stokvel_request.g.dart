// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_stokvel_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateStokvelRequest _$UpdateStokvelRequestFromJson(
  Map<String, dynamic> json,
) => UpdateStokvelRequest(
  version: json['version'] as String?,
  name: json['name'] as String?,
  contributionAmount: json['contributionAmount'],
);

Map<String, dynamic> _$UpdateStokvelRequestToJson(
  UpdateStokvelRequest instance,
) => <String, dynamic>{
  'version': instance.version,
  'name': instance.name,
  'contributionAmount': instance.contributionAmount,
};
