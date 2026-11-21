// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/home_stokvel_response.dart';
import '../models/me_response.dart';
import '../models/paged_response_of_contribution_response.dart';

part 'me_client.g.dart';

@RestApi()
abstract class MeClient {
  factory MeClient(Dio dio, {String? baseUrl}) = _MeClient;

  @GET('/api/v1/me')
  Future<MeResponse> getApiV1Me();

  @GET('/api/v1/me/activity')
  Future<PagedResponseOfContributionResponse> getApiV1MeActivity({
    @Query('pageToken') String? pageToken,
    @Query('pageSize') int? pageSize = 20,
  });

  @GET('/api/v1/me/home')
  Future<List<HomeStokvelResponse>> getApiV1MeHome();
}
