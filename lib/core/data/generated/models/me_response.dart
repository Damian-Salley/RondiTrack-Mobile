// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'me_response.g.dart';

@JsonSerializable()
class MeResponse {
  const MeResponse({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory MeResponse.fromJson(Map<String, Object?> json) =>
      _$MeResponseFromJson(json);

  final dynamic id;
  final String firstName;
  final String lastName;
  final String email;

  Map<String, Object?> toJson() => _$MeResponseToJson(this);
}
