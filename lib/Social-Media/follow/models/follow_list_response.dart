import 'package:dx/Social-Media/follow/models/follow_account.dart';

class FollowListResponse {
  const FollowListResponse({
    required this.items,
    required this.total,
    required this.limit,
    required this.offset,
  });

  final List<FollowAccount> items;
  final int total;
  final int limit;
  final int offset;

  factory FollowListResponse.fromJson(Map<String, dynamic> json) {
    final meta = json['meta'] as Map<String, dynamic>;
    return FollowListResponse(
      items: (json['items'] as List)
          .map((e) => FollowAccount.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: meta['total'] as int,
      limit: meta['limit'] as int,
      offset: meta['offset'] as int,
    );
  }

  bool get hasMore => offset + limit < total;
}
