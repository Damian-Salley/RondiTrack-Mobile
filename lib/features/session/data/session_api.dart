import 'package:ronditrack_mobile/core/data/api_client.dart';
import 'package:ronditrack_mobile/core/data/api_result.dart';
import 'package:ronditrack_mobile/core/data/generated/models/login_request.dart';
import 'package:ronditrack_mobile/core/result.dart';

/// Reads only the in-memory access token from the login response.
Future<Result<String>> signInToApi(
  ApiClient client,
  String email,
  String password,
) => apiResult(() async {
  final response = await client.rest.auth.postApiV1AuthLogin(
    body: LoginRequest(email: email, password: password),
  );
  return response.accessToken;
});
