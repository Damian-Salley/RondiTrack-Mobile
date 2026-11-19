import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_mobile/core/data/api_client.dart';
import 'package:ronditrack_mobile/core/data/api_result.dart';
import 'package:ronditrack_mobile/core/data/generated/models/login_request.dart';
import 'package:ronditrack_mobile/core/result.dart';

typedef SeedSignIn = Future<Result<String>> Function(
  String email,
  String password,
);

final seedSignInProvider = Provider<SeedSignIn>((ref) {
  final client = ref.watch(apiClientProvider);
  return (email, password) => apiResult(() async {
    final response = await client.auth.postApiV1AuthLogin(
      body: LoginRequest(email: email, password: password),
    );
    return response.accessToken;
  });
});

/// Give the auth provider a token update callback.
final updateTokenProvider = Provider<void Function(String?)>((ref) {
  final token = ref.watch(accessTokenProvider);
  return (value) => token.value = value;
});
