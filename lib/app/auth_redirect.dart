import 'package:ronditrack_mobile/features/session/presentation/auth_provider.dart';

/// Only known internal addresses can survive sign-in. Never trust a return URL.
String safeDestination(String? destination) {
  if (destination == null) return '/home';
  final uri = Uri.tryParse(destination);
  if (uri == null ||
      uri.hasScheme ||
      uri.hasAuthority ||
      uri.hasQuery ||
      uri.hasFragment ||
      destination.contains(r'\')) {
    return '/home';
  }
  final path = uri.path;
  if (const {'/home', '/stokvels', '/activity', '/profile'}.contains(path) ||
      RegExp(
        r'^/stokvels/[^/%]+(?:/cycles/[^/%]+(?:/payouts|/close-preview)?)?$',
      ).hasMatch(path) ||
      RegExp(r'^/join/[A-Za-z0-9_-]+$').hasMatch(path)) {
    return path;
  }
  return '/home';
}

/// Keeps the intended internal address through splash and both forms.
String? authRedirect(AuthState auth, Uri address) {
  final onForm = address.path == '/sign-in' || address.path == '/register';
  final onSplash = address.path == '/restore';
  final internal =
      const {
            'ronditrack-dev',
            'ronditrack-staging',
            'ronditrack',
          }.contains(address.scheme) &&
          address.host == 'app'
      ? address.path
      : address.toString();
  final destination = safeDestination(
    onForm || onSplash ? address.queryParameters['from'] : internal,
  );
  String to(String path) =>
      Uri(path: path, queryParameters: {'from': destination}).toString();

  return switch (auth) {
    Restoring() => onSplash ? null : to('/restore'),
    SignedOut() => onForm ? null : to('/sign-in'),
    SignedIn() => onForm || onSplash ? destination : null,
  };
}
