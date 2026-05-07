import 'package:dx/core/api/api_client.dart';
import 'package:dx/core/api/endpoints.dart';
import 'package:dx/Social-Media/follow/models/follow_list_response.dart';

class FollowService {
  static const int _defaultLimit = 15;

  Future<bool> checkFollowStatus(String userId) async {
    final res = await ApiClient.instance.get<Map<String, dynamic>>(
      Endpoints.followStatus(userId),
    );
    return res.data!['isFollowing'] as bool;
  }

  Future<void> follow(String userId) async {
    await ApiClient.instance.post<void>(
      Endpoints.follow,
      data: {'followingId': userId},
    );
  }

  Future<void> unfollow(String userId) async {
    await ApiClient.instance.delete<void>(Endpoints.unfollow(userId));
  }

  Future<FollowListResponse> getMyFollowers({
    int limit = _defaultLimit,
    int offset = 0,
  }) async {
    final res = await ApiClient.instance.get<Map<String, dynamic>>(
      Endpoints.myFollowers,
      queryParameters: {'limit': limit, 'offset': offset},
    );
    return FollowListResponse.fromJson(res.data!);
  }

  Future<FollowListResponse> getMyFollowing({
    int limit = _defaultLimit,
    int offset = 0,
  }) async {
    final res = await ApiClient.instance.get<Map<String, dynamic>>(
      Endpoints.myFollowing,
      queryParameters: {'limit': limit, 'offset': offset},
    );
    return FollowListResponse.fromJson(res.data!);
  }

  Future<FollowListResponse> getUserFollowers(
    String userId, {
    int limit = _defaultLimit,
    int offset = 0,
  }) async {
    final res = await ApiClient.instance.get<Map<String, dynamic>>(
      Endpoints.userFollowers(userId),
      queryParameters: {'limit': limit, 'offset': offset},
    );
    return FollowListResponse.fromJson(res.data!);
  }

  Future<FollowListResponse> getUserFollowing(
    String userId, {
    int limit = _defaultLimit,
    int offset = 0,
  }) async {
    final res = await ApiClient.instance.get<Map<String, dynamic>>(
      Endpoints.userFollowing(userId),
      queryParameters: {'limit': limit, 'offset': offset},
    );
    return FollowListResponse.fromJson(res.data!);
  }
}
