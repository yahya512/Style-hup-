class FollowAccount {
  const FollowAccount({
    required this.id,
    this.name,
    this.username,
    this.profileImageUrl,
  });

  final String id;
  final String? name;
  final String? username;
  final String? profileImageUrl;

  factory FollowAccount.fromJson(Map<String, dynamic> json) => FollowAccount(
        id: json['id'] as String,
        name: json['name'] as String?,
        username: json['username'] as String?,
        profileImageUrl: json['profileImageUrl'] as String?,
      );

  String get displayName => name ?? username ?? 'Unknown';
}
