// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/close_preview.dart';

part 'join_payment_closing_client.g.dart';

@RestApi()
abstract class JoinPaymentClosingClient {
  factory JoinPaymentClosingClient(Dio dio, {String? baseUrl}) =
      _JoinPaymentClosingClient;

  @GET('/api/v1/contributioncycles/{cycleId}/close-preview')
  Future<ClosePreview> getApiV1ContributioncyclesCycleIdClosePreview({
    @Path('cycleId') required int cycleId,
  });
}
