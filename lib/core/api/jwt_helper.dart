import 'dart:convert';

/// Lightweight JWT utility — decodes the payload without verifying the
/// signature. Used only to read the [exp] claim for proactive token refresh.
/// Never use this for security decisions on the backend.
class JwtHelper {
  JwtHelper._();

  /// Returns `true` when [token] is absent, malformed, or its [exp] claim is
  /// within [leewaySeconds] of expiring. Defaults to a 30-second leeway to
  /// absorb minor clock skew between client and server.
  static bool isExpired(String? token, {int leewaySeconds = 30}) {
    if (token == null || token.isEmpty) return true;
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;

      // JWT payload is base64url — pad to a multiple of 4 before decoding.
      final normalized = base64Url.normalize(parts[1]);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final claims = json.decode(decoded) as Map<String, dynamic>;

      final exp = claims['exp'];
      if (exp == null) return true;

      final expiry = DateTime.fromMillisecondsSinceEpoch(
        (exp as int) * 1000,
        isUtc: true,
      );
      return DateTime.now().toUtc().isAfter(
            expiry.subtract(Duration(seconds: leewaySeconds)),
          );
    } catch (_) {
      return true;
    }
  }
}
