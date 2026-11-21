// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'contribution_response.dart';

part 'paged_response_of_contribution_response.g.dart';

@JsonSerializable()
class PagedResponseOfContributionResponse {
  const PagedResponseOfContributionResponse({this.items, this.nextPageToken});

  factory PagedResponseOfContributionResponse.fromJson(
    Map<String, Object?> json,
  ) => _$PagedResponseOfContributionResponseFromJson(json);

  final List<ContributionResponse>? items;
  final String? nextPageToken;

  Map<String, Object?> toJson() =>
      _$PagedResponseOfContributionResponseToJson(this);
}
