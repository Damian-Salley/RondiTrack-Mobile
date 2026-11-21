// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/contribution_cycle_response.dart';
import '../models/create_contribution_cycle_request.dart';

part 'contribution_cycles_client.g.dart';

@RestApi()
abstract class ContributionCyclesClient {
  factory ContributionCyclesClient(Dio dio, {String? baseUrl}) =
      _ContributionCyclesClient;

  @GET('/api/v1/contributioncycles')
  Future<List<ContributionCycleResponse>> getApiV1Contributioncycles();

  @POST('/api/v1/contributioncycles')
  Future<ContributionCycleResponse> postApiV1Contributioncycles({
    @Body() required CreateContributionCycleRequest body,
  });
}
