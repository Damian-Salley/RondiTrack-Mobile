// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'auth_token_response.g.dart';

@JsonSerializable()
class AuthTokenResponse {
  const AuthTokenResponse({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
  });

  factory AuthTokenResponse.fromJson(Map<String, Object?> json) =>
      _$AuthTokenResponseFromJson(json);

  final String accessToken;
  final String tokenType;
  final dynamic expiresIn;

  Map<String, Object?> toJson() => _$AuthTokenResponseToJson(this);
}
