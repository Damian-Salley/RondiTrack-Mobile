// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'close_member.dart';

part 'close_preview.g.dart';

@JsonSerializable()
class ClosePreview {
  const ClosePreview({
    required this.cycleId,
    required this.cycleName,
    required this.asOfDate,
    required this.version,
    required this.members,
    required this.totalCents,
  });

  factory ClosePreview.fromJson(Map<String, Object?> json) =>
      _$ClosePreviewFromJson(json);

  final dynamic cycleId;
  final String cycleName;
  final String asOfDate;
  final String version;
  final List<CloseMember> members;
  final dynamic totalCents;

  Map<String, Object?> toJson() => _$ClosePreviewToJson(this);
}
