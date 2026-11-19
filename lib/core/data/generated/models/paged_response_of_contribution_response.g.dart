// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paged_response_of_contribution_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PagedResponseOfContributionResponse
_$PagedResponseOfContributionResponseFromJson(Map<String, dynamic> json) =>
    PagedResponseOfContributionResponse(
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => ContributionResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextPageToken: json['nextPageToken'] as String?,
    );

Map<String, dynamic> _$PagedResponseOfContributionResponseToJson(
  PagedResponseOfContributionResponse instance,
) => <String, dynamic>{
  'items': instance.items,
  'nextPageToken': instance.nextPageToken,
};
