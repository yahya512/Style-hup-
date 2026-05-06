import 'package:dx/core/api/api_client.dart';
import 'package:dx/core/api/endpoints.dart';
import 'package:dx/Social-Media/interactions/models/comment_model.dart';
import 'package:dx/Social-Media/interactions/models/reaction_model.dart';

class ReactionPage {
  const ReactionPage({required this.items, required this.hasMore});
  final List<ReactionModel> items;
  final bool hasMore;
}

class CommentPage {
  const CommentPage({required this.items, required this.hasMore});
  final List<CommentModel> items;
  final bool hasMore;
}

class InteractionService {
  static const int _defaultLimit = 10;

  // ── Reactions ──────────────────────────────────────────────────────────────

  Future<bool> checkReactionStatus(String postId) async {
    final response = await ApiClient.instance.get<Map<String, dynamic>>(
      Endpoints.reactionStatus(postId),
    );
    return response.data?['reacted'] as bool? ?? false;
  }

  Future<void> toggleReaction(String postId) async {
    await ApiClient.instance.post<dynamic>(
      '${Endpoints.reactions}/$postId',
    );
  }

  Future<void> removeReaction(String postId) async {
    await ApiClient.instance.delete<dynamic>(
      '${Endpoints.reactions}/$postId',
    );
  }

  Future<ReactionPage> getReactions(
    String postId, {
    int offset = 0,
    int limit = _defaultLimit,
  }) async {
    final response = await ApiClient.instance.get<Map<String, dynamic>>(
      '${Endpoints.reactions}/$postId',
      queryParameters: {'limit': limit, 'offset': offset},
    );
    final body = response.data!;
    final List<dynamic> raw = body['items'] as List<dynamic>? ?? const [];
    final meta = body['meta'] as Map<String, dynamic>?;
    final int total = (meta?['total'] as num?)?.toInt() ?? raw.length;
    final items = raw
        .map((e) => ReactionModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return ReactionPage(items: items, hasMore: offset + items.length < total);
  }

  // ── Comments ───────────────────────────────────────────────────────────────

  Future<CommentModel> addComment({
    required String postId,
    required String content,
  }) async {
    final response = await ApiClient.instance.post<Map<String, dynamic>>(
      Endpoints.comments,
      data: {'postId': postId, 'content': content},
    );
    return CommentModel.fromJson(response.data!);
  }

  Future<CommentModel> editComment({
    required String commentId,
    required String content,
  }) async {
    final response = await ApiClient.instance.patch<Map<String, dynamic>>(
      '${Endpoints.comments}/$commentId',
      data: {'content': content},
    );
    return CommentModel.fromJson(response.data!);
  }

  Future<void> deleteComment(String commentId) async {
    await ApiClient.instance.delete<dynamic>(
      '${Endpoints.comments}/$commentId',
    );
  }

  Future<CommentPage> getComments(
    String postId, {
    int offset = 0,
    int limit = _defaultLimit,
  }) async {
    final response = await ApiClient.instance.get<Map<String, dynamic>>(
      '${Endpoints.comments}/$postId',
      queryParameters: {'limit': limit, 'offset': offset},
    );
    final body = response.data!;
    final List<dynamic> raw = body['items'] as List<dynamic>? ?? const [];
    final meta = body['meta'] as Map<String, dynamic>?;
    final int total = (meta?['total'] as num?)?.toInt() ?? raw.length;
    final items = raw
        .map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return CommentPage(items: items, hasMore: offset + items.length < total);
  }
}
