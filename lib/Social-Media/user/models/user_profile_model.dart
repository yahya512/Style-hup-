class UserProfileModel {
  const UserProfileModel({
    required this.id,
    required this.username,
    required this.numberOfFollowers,
    required this.numberOfFollowing,
    required this.numberOfPosts,
    this.bio,
    this.profileImageUrl,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.gender,
    this.posts = const [],
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    // Safety check: API might return {} (Map) or [] (List) for posts
    final rawPosts = json['posts'];
    final List<Map<String, dynamic>> postsList = (rawPosts is List)
        ? rawPosts.whereType<Map<String, dynamic>>().toList()
        : const [];

    return UserProfileModel(
      id: json['id'] as String,
      username: json['username'] as String,
      bio: json['bio'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      gender: json['gender'] as String?,
      numberOfFollowers: (json['numberOfFollowers'] as num?)?.toInt() ?? 0,
      numberOfFollowing: (json['numberOfFollowing'] as num?)?.toInt() ?? 0,
      numberOfPosts: (json['numberOfPosts'] as num?)?.toInt() ?? 0,
      posts: postsList,
    );
  }

  final String id;
  final String username;
  final String? bio;
  final String? profileImageUrl;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? gender;
  final int numberOfFollowers;
  final int numberOfFollowing;
  final int numberOfPosts;
  final List<Map<String, dynamic>> posts;

  String get displayName {
    final full = [firstName, lastName]
        .where((s) => s != null && s.isNotEmpty)
        .join(' ');
    return full.isNotEmpty ? full : username;
  }
}