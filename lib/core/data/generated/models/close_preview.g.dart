// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'close_preview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClosePreview _$ClosePreviewFromJson(Map<String, dynamic> json) => ClosePreview(
  cycleId: json['cycleId'],
  cycleName: json['cycleName'] as String,
  asOfDate: json['asOfDate'] as String,
  version: json['version'] as String,
  members: (json['members'] as List<dynamic>)
      .map((e) => CloseMember.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalCents: json['totalCents'],
);

Map<String, dynamic> _$ClosePreviewToJson(ClosePreview instance) =>
    <String, dynamic>{
      'cycleId': instance.cycleId,
      'cycleName': instance.cycleName,
      'asOfDate': instance.asOfDate,
      'version': instance.version,
      'members': instance.members,
      'totalCents': instance.totalCents,
    };
