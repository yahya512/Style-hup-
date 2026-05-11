import 'package:dx/Authentication/models/forget_password_model.dart';
import 'package:dx/Authentication/models/refresh_token_model.dart';
import 'package:dx/Authentication/models/reset_password_model.dart';
import 'package:dx/E-Commerce/Models/all_products_list_model.dart';
import 'package:dx/E-Commerce/Models/get_product_by_id_model.dart';
import 'package:dx/core/api/api_consumer.dart';
import 'package:dx/core/api/endpoints.dart';
import 'package:dx/Authentication/models/brand_complete_profile_model.dart';
import 'package:dx/Authentication/models/loginmodel.dart';
import 'package:dx/Authentication/models/signupmodel.dart';
import 'package:dx/Authentication/models/user_complete_profile_model.dart';
import 'package:dx/Authentication/models/user_get_profile_model.dart';
import 'package:dx/core/functions/upload_image_to_api.dart';
import 'package:image_picker/image_picker.dart';

class UserRepository {
  final ApiConsumer _api;
  UserRepository({required ApiConsumer api}) : _api = api;

  // Log IN
  Future<LoginModel> login(String email, String password) async {
    final response = await _api.post(
      Endpoints.logIn,
      data: {ApiKey.email: email, ApiKey.password: password},
    );
    return LoginModel.fromJson(response);
  }

  // Sign UP
  Future<Signupmodel> signup(
    String? role,
    String email,
    String? password,
    String? confirmationPassword,
  ) async {
    final response = await _api.post(
      Endpoints.signUp,
      data: {
        ApiKey.role: role,
        ApiKey.email: email,
        ApiKey.password: password,
        ApiKey.confirmationPassword: confirmationPassword,
      },
    );
    return Signupmodel.fromJson(response);
  }

  // Brand Complete profile
  Future<BrandCompleteProfileModel> brandCompleteProfile(
    String userName,
    String phoneNumber,
    String brandName,
    String brandDomain,
    String description,
  ) async {
    final response = await _api.post(
      Endpoints.brandCompleteProfile,
      data: {
        ApiKey.userName: userName,
        ApiKey.phoneNumber: phoneNumber,
        ApiKey.brandName: brandName,
        ApiKey.brandDomain: brandDomain,
        ApiKey.description: description,
      },
    );
    return BrandCompleteProfileModel.fromJson(response);
  }

  // User Complete profile
  Future<UserCompleteProfileModel> userCompleteProfile(
    String userName,
    String firstName,
    String lastName,
    String phone,
    String bio,
    String gender,
  ) async {
    final response = await _api.post(
      Endpoints.userCompleteProfile,
      data: {
        ApiKey.userName: userName,
        ApiKey.firstName: firstName,
        ApiKey.lastName: lastName,
        ApiKey.phoneNumber: phone,
        ApiKey.description: bio,
        ApiKey.gender: gender,
      },
    );
    return UserCompleteProfileModel.fromJson(response);
  }

  // USER GetProfile
  Future<UserGetProfileModel> userGetProfile() async {
    final response = await _api.get(Endpoints.userGetProfile);
    return UserGetProfileModel.fromJson(response);
  }

  //Upload Image
  Future imageupload(XFile? brandPhoto) async {
    await _api.post(
      isFormdata: true,
      Endpoints.brandProfileImage,
      data: {ApiKey.brandProfile: await uploadimageToApi(brandPhoto!)},
    );
  }

  //Refersh Token
  Future<RefreshTokenModel> refreshtoken(String refreshToken) async {
    final response = await _api.post(
      Endpoints.refreshToken,
      data: {ApiKey.refreshToken: refreshToken},
    );
    return RefreshTokenModel.fromJson(response);
  }

  //Forget Password
  Future<ForgetPasswordModel> forgetPassword(String role, String email) async {
    final response = await _api.post(
      Endpoints.forgetPassword,
      data: {ApiKey.role: role, ApiKey.email: email},
    );
    return ForgetPasswordModel.fromJson(response);
  }

  // Logout
  Future<void> logout() async {
    await _api.post(Endpoints.logout, data: {});
  }

  // reset password

  Future<ResetPasswordModel> resetPassword(
    String role,
    String email,
    String verifiedCode,
    String newPassword,
    String newConfirmPassword,
  ) async {
    final response = await _api.post(
      Endpoints.resetPassword,
      data: {
        ApiKey.role: role,
        ApiKey.email: email,
        ApiKey.verifiedCode: verifiedCode,
        ApiKey.newPassword: newPassword,
        ApiKey.newConfirmationPassword: newConfirmPassword,
      },
    );
    return ResetPasswordModel.fromJson(response);
  }

  // GET all products list
  Future<AllProductsListModel> getAllProductsList(int page, int size) async {
    final response = await _api.get(
      Endpoints.getAllProductsByBrandId("bee53d22-d94d-4d21-829b-267a011f6921"),
      queryparametars: {ApiKey.page: page, ApiKey.size: size},
    );

    return AllProductsListModel.fromJson(response);
  }

  // add product to wishlist
  Future<String> addToWishlist(String productId) async {
    final response = await _api.post(
        Endpoints.getWishlistByBrandId("bee53d22-d94d-4d21-829b-267a011f6921"),
        queryparametars: {ApiKey.productId: productId});
    return response;
  }

  // Remove product to Wishlist
  Future<String> removeFromWishlist(String productId) async {
    final response = await _api.delete(
        Endpoints.getWishlistByBrandId("bee53d22-d94d-4d21-829b-267a011f6921"),
        queryparametars: {ApiKey.productId: productId});
    return response;
  }

  // Get Wishlist
  Future<AllProductsListModel> getWishlist(int page, int size) async {
    final response = await _api.get(
      Endpoints.getWishlistByBrandId("bee53d22-d94d-4d21-829b-267a011f6921"),
      queryparametars: {ApiKey.page: page, ApiKey.size: size},
    );
    return AllProductsListModel.fromJson(response);
  }

  // Get Product by id
  Future<GetProductByIdModel> getProductById(
      String brandid, String productId) async {
    final response =
        await _api.get(Endpoints.getProductsById(brandid, productId));
    return GetProductByIdModel.fromJson(response);
  }
}
