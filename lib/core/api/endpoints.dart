class Endpoints {
  static String baseUrl =
      "https://style-hub-social-media-be-d369dfc7ce40.herokuapp.com/";

  static String logIn = "auth/login";
  static String logout = "auth/logout";
  static String signUp = "auth/register";
  static String forgetPassword = "auth/forgot-password";
  static String resetPassword = "auth/reset-password";
  static String brandCompleteProfile = "brand/complete-profile";
  static String userCompleteProfile = "user/complete-profile";
  static String brandProfileImage = "brand/profile/image";
  static String userGetProfile = "user/profile";
  static String userProfileImage = "user/profile/image";
  static String userDeleteAccount = "user/account";
  static String brandGetProfile = "brand/profile";
  static String brandUpdateProfileImage = "brand/profile/image";
  static String brandDeleteAccount = "brand/account";
  static String createPost = "posts";
  static String search = "search";
  static String searchUser = "search/user";
  static String searchBrand = "search/brand";
  static String refreshToken = "auth/refresh";
  static String reactions = "interactions/reactions";
  static String reactionStatus(String postId) =>
      "interactions/reactions/$postId/status";
  static String comments = "interactions/comments";
  static String myPosts = "posts/me";
  static String postById(String id) => "posts/$id";
  static String otherUserProfile(String userId) => "user/$userId/profile";
  static String otherBrandProfile(String userId) => "brand/$userId/profile";
  static String searchAccount(String id) => "search/account/$id";

  // Notification endpoints
  static const String notifications = 'notifications';
  static const String notificationsUnreadCount = 'notifications/unread-count';
  static String notificationRead(String id) => 'notifications/$id/read';
  static const String notificationsReadAll = 'notifications/read-all';

  // Follow endpoints
  static String followStatus(String userId) => "follow/status/$userId";
  static const String follow = "follow";
  static String unfollow(String followingId) => "follow/$followingId";
  static const String myFollowers = "follow/followers";
  static const String myFollowing = "follow/following";
  static String userFollowers(String userId) => "follow/$userId/followers";
  static String userFollowing(String userId) => "follow/$userId/following";
}

class ApiKey {
  static const String authorization = "Authorization";
  static const String message = "message";
  static const String error = "error";
  static const String statusCode = "statusCode";
  static const String accessToken = "accessToken";
  static const String refreshToken = "refreshToken";

  // return role , id , email ,isprofilecomplete
  static const String userinfo = "user";
  static const String id = "id";
  static const String role = "role";
  static const String email = "email";
  static const String isProfileComplete = "isProfileComplete";
  static const String password = "password";
  static const String confirmationPassword = "confirmationPassword";
  static const String newConfirmationPassword = "newConfirmationPassword";
  static const String newPassword = "newPassword";
  static const String baseUserId = "baseUserId";
  static const String userName = "username";
  static const String firstName = "firstName";
  static const String lastName = "lastName";
  static const String description = "bio";
  static const String gender = "gender";
  static const String brandName = "brandName";
  static const String brandDomain = "websiteUrl";
  static const String userprogfile = "file";
  static const String brandProfile = "file";
  static const String phoneNumber = "phoneNumber";
  static const String userId = "userId";
  static const String isVerified = "isVerified";
  static const String status = "status";
  static const String createdAt = "createdAt";
  static const String updatedAt = "updatedAt";
  static const String profileImageUrl = "profileImageUrl";
  static const String numberOfFollowers = "numberOfFollowers";
  static const String numberOfFollowing = "numberOfFollowing";
  static const String numberOfPosts = "numberOfPosts";
  static const String posts = "numberOfPosts";
  static const String verifiedCode = "token";
}
