// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';

import 'auth/auth_client.dart';
import 'contribution_cycles/contribution_cycles_client.dart';
import 'join_payment_closing/join_payment_closing_client.dart';
import 'me/me_client.dart';
import 'stokvels/stokvels_client.dart';

/// RondiTrack | v1 `v1.0.0`
class RondiTrackClient {
  RondiTrackClient(Dio dio, {String? baseUrl}) : _dio = dio, _baseUrl = baseUrl;

  final Dio _dio;
  final String? _baseUrl;

  static String get version => '1.0.0';

  AuthClient? _auth;
  ContributionCyclesClient? _contributionCycles;
  JoinPaymentClosingClient? _joinPaymentClosing;
  MeClient? _me;
  StokvelsClient? _stokvels;

  AuthClient get auth => _auth ??= AuthClient(_dio, baseUrl: _baseUrl);

  ContributionCyclesClient get contributionCycles =>
      _contributionCycles ??= ContributionCyclesClient(_dio, baseUrl: _baseUrl);

  JoinPaymentClosingClient get joinPaymentClosing =>
      _joinPaymentClosing ??= JoinPaymentClosingClient(_dio, baseUrl: _baseUrl);

  MeClient get me => _me ??= MeClient(_dio, baseUrl: _baseUrl);

  StokvelsClient get stokvels =>
      _stokvels ??= StokvelsClient(_dio, baseUrl: _baseUrl);
}
