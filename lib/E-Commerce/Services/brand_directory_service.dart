import 'package:dx/E-Commerce/Models/brand_directory_model.dart';
import 'package:dx/core/api/api_consumer.dart';
import 'package:dx/core/api/endpoints.dart';

class BrandDirectoryService {
  final ApiConsumer _api;
  BrandDirectoryService({required ApiConsumer api}) : _api = api;

  Future<BrandDirectoryResult> getBrands({
    int limit = 20,
    int offset = 0,
  }) async {
    final response = await _api.get(
      Endpoints.brands,
      queryparametars: {'limit': limit, 'offset': offset},
    );
    return BrandDirectoryResult.fromJson(response as Map<String, dynamic>);
  }
}
