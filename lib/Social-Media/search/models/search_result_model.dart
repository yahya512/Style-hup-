enum AccountType { user, brand }

AccountType _accountTypeFromString(String raw) =>
    raw.toUpperCase() == 'BRAND' ? AccountType.brand : AccountType.user;

class SearchResultModel {
  const SearchResultModel({
    required this.id,
    required this.type,
    required this.username,
    this.firstName,
    this.lastName,
    this.brandName,
    this.profileImageUrl,
  });

  factory SearchResultModel.fromJson(Map<String, dynamic> json) =>
      SearchResultModel(
        id: json['id'] as String,
        type: _accountTypeFromString(json['type'] as String? ?? 'USER'),
        username: json['username'] as String,
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        brandName: json['brandName'] as String?,
        profileImageUrl: json['profileImageUrl'] as String?,
      );

  final String id;
  final AccountType type;
  final String username;
  final String? firstName;
  final String? lastName;
  final String? brandName;
  final String? profileImageUrl;

  String get displayName {
    if (type == AccountType.brand &&
        brandName != null &&
        brandName!.isNotEmpty) {
      return brandName!;
    }
    final full = [firstName, lastName]
        .where((s) => s != null && s.isNotEmpty)
        .join(' ');
    return full.isNotEmpty ? full : username;
  }
}
