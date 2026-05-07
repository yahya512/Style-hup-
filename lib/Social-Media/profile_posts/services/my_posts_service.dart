import 'package:dio/dio.dart';
import 'package:dx/core/api/api_client.dart';
import 'package:dx/core/api/endpoints.dart';
import 'package:dx/Social-Media/feed/models/post_model.dart';

/// Result of a single paginated page of the current user's posts.
class MyPostsPage {
  const MyPostsPage({required this.items, required this.hasMore});

  final List<FeedPostModel> items;

  /// True when [offset + items.length < total] — more pages remain.
  final bool hasMore;
}

/// Calls `GET /posts/me` and maps the `PaginationResponse<Post>` into
/// [MyPostsPage].
///
/// Pagination uses offset-based params: `limit` (default 10) + `offset`.
class MyPostsService {
  static const int defaultLimit = 10;

  Future<MyPostsPage> getMyPosts({
    int offset = 0,
    int limit = defaultLimit,
  }) async {
    final Response<Map<String, dynamic>> response =
        await ApiClient.instance.get<Map<String, dynamic>>(
      Endpoints.myPosts,
      queryParameters: {'limit': limit, 'offset': offset},
    );

    final body = response.data!;
    final List<dynamic> raw = body['items'] as List<dynamic>? ?? const [];
    final meta = body['meta'] as Map<String, dynamic>?;
    final int total = (meta?['total'] as num?)?.toInt() ?? raw.length;

    final items = raw
        .map((e) => FeedPostModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return MyPostsPage(
      items: items,
      hasMore: offset + items.length < total,
    );
  }

  Future<void> deletePost(String postId) async {
    await ApiClient.instance.delete<dynamic>(Endpoints.postById(postId));
  }

  Future<void> updatePost(
    String postId, {
    String? content,
    PostVisibility? visibility,
  }) async {
    final data = <String, dynamic>{};
    if (content != null) data['content'] = content;
    if (visibility != null) data['visibility'] = visibility.name.toUpperCase();
    await ApiClient.instance.patch<dynamic>(
      Endpoints.postById(postId),
      data: data,
    );
  }
}
