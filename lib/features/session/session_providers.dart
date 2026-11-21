import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_mobile/core/data/api_client.dart';
import 'package:ronditrack_mobile/core/result.dart';
import 'package:ronditrack_mobile/features/session/data/session_api.dart';

typedef SeedSignIn = Future<Result<String>> Function(String, String);

final seedSignInProvider = Provider<SeedSignIn>((ref) {
  final client = ref.watch(apiClientProvider);
  return (email, password) => signInToApi(client, email, password);
});

/// Auth can update the in-memory token without seeing a transport type.
final updateTokenProvider = Provider<void Function(String?)>((ref) {
  final token = ref.watch(accessTokenProvider);
  return (value) => token.value = value;
});
