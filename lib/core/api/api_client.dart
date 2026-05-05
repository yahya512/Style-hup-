import 'package:dio/dio.dart';
import 'package:dx/core/services/service_locator.dart';

/// Thin accessor so feature layers can call [ApiClient.instance]
/// without coupling to GetIt directly.
///
/// The returned [Dio] is already configured with [Endpoints.baseUrl]
/// and [ApiInterceptors] (auto Bearer-token injection + silent refresh).
class ApiClient {
  ApiClient._();

  static Dio get instance => getIt<Dio>();
}
