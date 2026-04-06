import 'package:dx/core/api/endpoints.dart';

class UserGetProfileModel {
  final String id;
  final String type;
  final String userName;
  final String firstName;
  final String lastName;
  final String gender;
  final String phone;
  final String numberOfFollowers;
  final String numberOfFollowing;
  final String numberofPosts;
  final String posts;
  final String bio;
  final String profileImageUrl;

  UserGetProfileModel({
    required this.id,
    required this.type,
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.phone,
    required this.numberOfFollowers,
    required this.numberOfFollowing,
    required this.numberofPosts,
    required this.posts,
    required this.bio,
    required this.profileImageUrl,
  });

  factory UserGetProfileModel.fromJson(Map<String, dynamic> jsonData) {
    return UserGetProfileModel(
      id: jsonData[ApiKey.id],
      type: jsonData[ApiKey.role],
      userName: jsonData[ApiKey.userName],
      firstName: jsonData[ApiKey.firstName],
      lastName: jsonData[ApiKey.lastName],
      gender: jsonData[ApiKey.gender],
      phone: jsonData[ApiKey.phoneNumber],
      numberOfFollowers: jsonData[ApiKey.numberOfFollowers],
      numberOfFollowing: jsonData[ApiKey.numberOfFollowing],
      numberofPosts: jsonData[ApiKey.numberOfPosts],
      posts: jsonData[ApiKey.posts],
      bio: jsonData[ApiKey.description],
      profileImageUrl: jsonData[ApiKey.profileImageUrl],
    );
  }
}
