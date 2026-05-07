import 'package:dx/Social-Media/brand/models/brand_profile_model.dart';
import 'package:dx/Social-Media/user/models/user_profile_model.dart';
import 'package:dx/core/api/api_client.dart';
import 'package:dx/core/api/endpoints.dart';

class OtherUserProfileService {
  /// Fetches a profile for any account type via the unified search endpoint.
  /// The server resolves whether the id belongs to a user or brand and returns
  /// the appropriate shape. We detect the type by the presence of [brandName].
  Future<UserProfileModel> getProfile(String userId) async {
    final response = await ApiClient.instance.get<Map<String, dynamic>>(
      Endpoints.searchAccount(userId),
    );
    final data = response.data!;
    if (data.containsKey('brandName')) {
      final brand = BrandProfileModel.fromJson(data);
      return UserProfileModel(
        id: brand.id,
        username: brand.username,
        bio: brand.bio,
        profileImageUrl: brand.profileImageUrl,
        firstName: brand.brandName,
        numberOfFollowers: brand.numberOfFollowers,
        numberOfFollowing: 0,
        numberOfPosts: brand.numberOfPosts,
      );
    }
    return UserProfileModel.fromJson(data);
  }
}
