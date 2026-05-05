import 'package:dx/core/api/api_client.dart';
import 'package:dx/core/api/endpoints.dart';
import 'package:dx/Social-Media/search/models/search_result_model.dart';
import 'package:dx/Social-Media/user/models/user_profile_model.dart';
import 'package:dx/Social-Media/brand/models/brand_profile_model.dart';

class SearchService {
  Future<List<SearchResultModel>> search(String query) async {
    final response = await ApiClient.instance.get<List<dynamic>>(
      Endpoints.search,
      queryParameters: {'query': query},
    );
    final raw = response.data ?? const [];
    return raw
        .map((e) => SearchResultModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<UserProfileModel> getUserById(String id) async {
    final response = await ApiClient.instance.get<Map<String, dynamic>>(
      '${Endpoints.searchUser}/$id',
    );
    return UserProfileModel.fromJson(response.data!);
  }

  Future<BrandProfileModel> getBrandById(String id) async {
    final response = await ApiClient.instance.get<Map<String, dynamic>>(
      '${Endpoints.searchBrand}/$id',
    );
    return BrandProfileModel.fromJson(response.data!);
  }
}
