class BrandDirectoryItem {
  final String id;
  final String username;
  final String? brandName;
  final String? profileImageUrl;

  const BrandDirectoryItem({
    required this.id,
    required this.username,
    this.brandName,
    this.profileImageUrl,
  });

  factory BrandDirectoryItem.fromJson(Map<String, dynamic> json) {
    return BrandDirectoryItem(
      id: json['id'] as String? ?? '',
      username: json['username'] as String? ?? '',
      brandName: json['brandName'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
    );
  }

  String get displayName =>
      brandName?.isNotEmpty == true ? brandName! : username;
}

class BrandDirectoryResult {
  final List<BrandDirectoryItem> items;
  final int total;
  final int limit;
  final int offset;

  const BrandDirectoryResult({
    required this.items,
    required this.total,
    required this.limit,
    required this.offset,
  });

  bool get hasMore => offset + limit < total;

  factory BrandDirectoryResult.fromJson(Map<String, dynamic> json) {
    final meta = json['meta'] as Map<String, dynamic>? ?? {};
    final rawItems = json['items'] as List<dynamic>? ?? [];
    return BrandDirectoryResult(
      items: rawItems
          .map((e) => BrandDirectoryItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: meta['total'] as int? ?? 0,
      limit: meta['limit'] as int? ?? 10,
      offset: meta['offset'] as int? ?? 0,
    );
  }
}
