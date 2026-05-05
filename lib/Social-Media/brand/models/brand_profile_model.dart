class BrandProfileModel {
  const BrandProfileModel({
    required this.id,
    required this.brandName,
    required this.username,
    required this.numberOfFollowers,
    required this.numberOfPosts,
    this.websiteUrl,
    this.bio,
    this.profileImageUrl,
    this.phoneNumber,
  });

  factory BrandProfileModel.fromJson(Map<String, dynamic> json) =>
      BrandProfileModel(
        id: json['id'] as String,
        brandName: json['brandName'] as String,
        username: json['username'] as String,
        websiteUrl: json['websiteUrl'] as String?,
        bio: json['bio'] as String?,
        profileImageUrl: json['profileImageUrl'] as String?,
        phoneNumber: json['phoneNumber'] as String?,
        numberOfFollowers: (json['numberOfFollowers'] as num?)?.toInt() ?? 0,
        numberOfPosts: (json['numberOfPosts'] as num?)?.toInt() ?? 0,
      );

  final String id;
  final String brandName;
  final String username;
  final String? websiteUrl;
  final String? bio;
  final String? profileImageUrl;
  final String? phoneNumber;
  final int numberOfFollowers;
  final int numberOfPosts;
}
