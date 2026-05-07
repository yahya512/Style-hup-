import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dx/core/api/api_client.dart';
import 'package:dx/core/api/endpoints.dart';
import 'package:dx/Social-Media/feed/models/post_model.dart';

/// Result of a single paginated page fetch.
class FeedPage {
  const FeedPage({required this.items, required this.hasMore});

  final List<FeedItemModel> items;

  /// True when [offset + items.length < total] — more pages remain.
  final bool hasMore;
}

/// Calls `GET /feed` and maps the `PaginationResponse<FeedItemResponseDto>`
/// into [FeedPage].
///
/// Pagination uses offset-based params: `limit` (default 10) + `offset`.
class FeedService {
  static const int defaultLimit = 10;

  Future<FeedPage> getFeed({
    int offset = 0,
    int limit = defaultLimit,
  }) async {
    final Response<Map<String, dynamic>> response =
        await ApiClient.instance.get<Map<String, dynamic>>(
      '/feed',
      queryParameters: {'limit': limit, 'offset': offset},
    );

    final body = response.data!;
    final List<dynamic> raw = body['items'] as List<dynamic>? ?? const [];
    final meta = body['meta'] as Map<String, dynamic>?;
    final int total = (meta?['total'] as num?)?.toInt() ?? raw.length;

    final items = raw
        .map((e) => FeedItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return FeedPage(
      items: items,
      hasMore: offset + items.length < total,
    );
  }

  Future<void> createPost({
    String? content,
    String visibility = 'PUBLIC',
    List<File> images = const [],
    List<File> videos = const [],
  }) async {
    final formData = FormData();

    if (content != null && content.isNotEmpty) {
      formData.fields.add(MapEntry('content', content));
    }
    formData.fields.add(MapEntry('visibility', visibility));

    for (final image in images) {
      formData.files.add(MapEntry(
        'images',
        await MultipartFile.fromFile(image.path),
      ));
    }
    for (final video in videos) {
      formData.files.add(MapEntry(
        'videos',
        await MultipartFile.fromFile(video.path),
      ));
    }

    await ApiClient.instance.post<dynamic>(
      Endpoints.createPost,
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
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
