import 'package:ronditrack_mobile/features/session/domain/persona.dart';

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
      RegExp(r'^/stokvels/[^/%]+(?:/cycles/[^/%]+)?$').hasMatch(path) ||
      RegExp(r'^/join/[A-Za-z0-9_-]+$').hasMatch(path)) {
    return path;
  }
  return '/home';
}

/// A pure gate: Riverpod supplies auth; the router supplies the address.
String? authRedirect(Persona? persona, Uri address) {
  final signingIn = address.path == '/sign-in';
  if (persona == null) {
    if (signingIn) return null;
    // Android supplies the custom scheme; only its internal path is remembered.
    final internal =
        const {
              'ronditrack-dev',
              'ronditrack-staging',
              'ronditrack',
            }.contains(address.scheme) &&
            address.host == 'app'
        ? address.path
        : address.toString();
    return Uri(
      path: '/sign-in',
      queryParameters: {'from': safeDestination(internal)},
    ).toString();
  }
  if (signingIn) return safeDestination(address.queryParameters['from']);
  return null;
}
