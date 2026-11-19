// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/contribution_response.dart';
import '../models/paged_response_of_contribution_response.dart';
import '../models/payout_order_entry_response.dart';
import '../models/record_cycle_contribution_request.dart';
import '../models/stokvel_response.dart';
import '../models/update_stokvel_request.dart';

part 'stokvels_client.g.dart';

@RestApi()
abstract class StokvelsClient {
  factory StokvelsClient(Dio dio, {String? baseUrl}) = _StokvelsClient;

  @GET('/api/v1/stokvels/{id}')
  Future<StokvelResponse> getApiV1StokvelsId({@Path('id') required int id});

  @PUT('/api/v1/stokvels/{id}')
  Future<void> putApiV1StokvelsId({
    @Path('id') required int id,
    @Body() required UpdateStokvelRequest body,
  });

  @DELETE('/api/v1/stokvels/{id}')
  Future<void> deleteApiV1StokvelsId({@Path('id') required int id});

  @POST('/api/v1/stokvels/{stokvelId}/cycles/{cycleId}/contributions')
  Future<ContributionResponse>
  postApiV1StokvelsStokvelIdCyclesCycleIdContributions({
    @Path('stokvelId') required int stokvelId,
    @Path('cycleId') required int cycleId,
    @Header('Idempotency-Key') required String idempotencyKey,
    @Body() required RecordCycleContributionRequest body,
  });

  @GET('/api/v1/stokvels/{stokvelId}/cycles/{cycleId}/contributions')
  Future<PagedResponseOfContributionResponse>
  getApiV1StokvelsStokvelIdCyclesCycleIdContributions({
    @Path('stokvelId') required int stokvelId,
    @Path('cycleId') required int cycleId,
    @Query('PageSize') int? pageSize,
    @Query('PageToken') String? pageToken,
    @Query('SortBy') String? sortBy,
    @Query('UserId') int? userId,
    @Query('From') DateTime? from,
    @Query('To') DateTime? to,
  });

  @GET('/api/v1/stokvels/{stokvelId}/cycles/{cycleId}/payouts')
  Future<List<PayoutOrderEntryResponse>>
  getApiV1StokvelsStokvelIdCyclesCycleIdPayouts({
    @Path('stokvelId') required int stokvelId,
    @Path('cycleId') required int cycleId,
  });
}
