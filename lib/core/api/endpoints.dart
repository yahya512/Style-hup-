import 'package:flutter_dotenv/flutter_dotenv.dart';

class Endpoints {
  static String baseUrl = dotenv.env['BASE_URL'] ??
      "https://style-hub-social-media-be-d369dfc7ce40.herokuapp.com/";
  static String commerceBaseUrl = dotenv.env['COMMERCE_BASE_URL'] ??
      "https://ecommerce-app-e6303c36e118.herokuapp.com/api/v1/";

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
  static String postsByUser(String userId) => "posts/user/$userId";

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

  // Chat endpoints
  static const String chatMessages = "chat/messages";
  static const String chatConversations = "chat/conversations";
  static String conversationMessages(String id) =>
      "chat/conversations/$id/messages";
  static String markConversationSeen(String id) =>
      "chat/conversations/$id/seen";

  // E-Commerce
  static String getAllProductsByBrandId(String id) {
    return "customer/brands/$id/products";
  }

  static String getProductsById(String brandid, String productId) {
    return "customer/brands/$brandid/products/$productId";
  }

  static String getWishlistByBrandId(String id) {
    return "customer/brands/$id/wishlist";
  }
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
  //Ecommerce
  static const String items = "items";
  static const String productId = "productId";
  static const String thumbnail = "thumbnail";
  static const String productNameEn = "productNameEn";
  static const String productNameAr = "productNameAr";
  static const String categoryNameEN = "categoryNameEN";
  static const String categoryNameAr = "categoryNameAr";
  static const String productDescriptionEn = "productDescriptionEn";
  static const String productDescriptionAr = "productDescriptionAr";
  static const String avgRating = "avgRating";
  static const String countColorsAvailable = "countColorsAvailable";
  static const String totalInStock = "totalInStock";
  static const String isFavourite = "isFavourite";
  static const String page = "page";
  static const String size = "size";
  static const String totalElements = "totalElements";
  static const String totalPages = "totalPages";
  static const String hasNext = "hasNext";
  static const String hasPrevious = "hasPrevious";
  static const String colorDetails = "colorDetails";
  static const String productColorId = "productColorId";
  static const String colorCode = "colorCode";
  static const String colorImages = "colorImages";
  static const String variantsDetailsDtos = "variantsDetailsDtos";
  static const String productVariantId = "productVariantId";
  static const String stock = "stock";
  static const String sku = "sku";
  static const String price = "price";
}
