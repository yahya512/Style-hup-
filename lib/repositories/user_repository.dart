import 'package:dx/Authentication/models/forget_password_model.dart';
import 'package:dx/Authentication/models/reset_password_model.dart';
import 'package:dx/E-Commerce/Models/all_products_list_model.dart';
import 'package:dx/E-Commerce/Models/get_brand_data_model.dart';
import 'package:dx/E-Commerce/Models/get_cart_model.dart';
import 'package:dx/E-Commerce/Models/get_product_by_id_model.dart';
import 'package:dx/E-Commerce/Models/parent_child_model.dart';
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

  //Forget Password
  Future<ForgetPasswordModel> forgetPassword(String email) async {
    final response = await _api.post(
      Endpoints.forgetPassword,
      data: {ApiKey.email: email},
    );
    return ForgetPasswordModel.fromJson(response);
  }

  // Logout
  Future<void> logout() async {
    await _api.post(Endpoints.logout, data: {});
  }

  // reset password
  Future<ResetPasswordModel> resetPassword(
    String email,
    String verifiedCode,
    String newPassword,
    String newConfirmPassword,
  ) async {
    final response = await _api.post(
      Endpoints.resetPassword,
      data: {
        ApiKey.email: email,
        ApiKey.verifiedCode: verifiedCode,
        ApiKey.newPassword: newPassword,
        ApiKey.newConfirmationPassword: newConfirmPassword,
      },
    );
    return ResetPasswordModel.fromJson(response);
  }

  // Search products within a brand
  Future<AllProductsListModel> searchBrandProducts(
      String brandId, String query, int page, int size) async {
    final response = await _api.get(
      Endpoints.searchProductsByBrand(brandId),
      queryparametars: {'search': query, ApiKey.page: page, ApiKey.size: size},
    );
    return AllProductsListModel.fromJson(response);
  }

  // GET all products list
  Future<AllProductsListModel> getAllProductsList(
      String brandId, int page, int size,
      [String? categoryId,
      String? minRating,
      String? minPrice,
      String? maxPrice,
      String? gender]) async {
    final Map<String, dynamic> queryParams = {
      ApiKey.page: page,
      ApiKey.size: size,
    };
    if (categoryId != null) queryParams[ApiKey.categoryId] = categoryId;
    if (minRating != null) queryParams[ApiKey.minRating] = minRating;
    if (minPrice != null) queryParams[ApiKey.minPrice] = minPrice;
    if (maxPrice != null) queryParams[ApiKey.maxPrice] = maxPrice;
    if (gender != null) queryParams[ApiKey.gender] = gender;

    final response = await _api.get(
        Endpoints.getAllProductsByBrandId(brandId),
        queryparametars: queryParams);

    return AllProductsListModel.fromJson(response);
  }

  // add product to wishlist
  Future<String> addToWishlist(String brandId, String productId) async {
    final response = await _api.post(
        Endpoints.getWishlistByBrandId(brandId),
        queryparametars: {ApiKey.productId: productId});
    return response;
  }

  // Remove product to Wishlist
  Future<String> removeFromWishlist(String brandId, String productId) async {
    final response = await _api.delete(
        Endpoints.getWishlistByBrandId(brandId),
        queryparametars: {ApiKey.productId: productId});
    return response;
  }

  // Get Wishlist
  Future<AllProductsListModel> getWishlist(
      String brandId, int page, int size) async {
    final response = await _api.get(
      Endpoints.getWishlistByBrandId(brandId),
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

  // ADD to Cart
  Future<String> addToCart(String brandId,
      [String quantity = "1", String? productVariantId]) async {
    final response = await _api.post(
        Endpoints.getCartByBrandId(brandId),
        isFormdata: true,
        data: {
          ApiKey.quantity: quantity,
          ApiKey.productVariantId: productVariantId
        });
    return (response as Map<String, dynamic>).keys.first;
  }

  // Get Cart
  Future<GetCartModel> getCart(String brandId) async {
    final response = await _api.get(
      Endpoints.getCartByBrandId(brandId),
      isFormdata: true,
    );
    return GetCartModel.fromJson(response);
  }

  // delete from cart
  Future<String> deleteFromCart(
      String brandId, String cartId, String cartItemId) async {
    final response = await _api
        .delete(Endpoints.deleteCartByBrandId(brandId, cartId, cartItemId));
    return response;
  }

  // update cart item quantity
  Future<void> updateCartItemQuantity(
      String brandId, String cartId, String cartItemId, int quantity) async {
    await _api.patch(
      Endpoints.updateCartItem(brandId, cartId, cartItemId),
      isFormdata: true,
      data: {ApiKey.quantity: quantity.toString()},
    );
  }

  // Checkout
  Future<void> checkout({
    required String brandId,
    required String cartId,
    required String streetEn,
    required String streetAr,
    required String cityEn,
    required String cityAr,
    required String buildingNumber,
  }) async {
    await _api.post(
      Endpoints.checkoutByBrandId(brandId),
      isFormdata: true,
      data: {
        ApiKey.cartId: cartId,
        ApiKey.streetEn: streetEn,
        ApiKey.streetAr: streetAr,
        ApiKey.cityEn: cityEn,
        ApiKey.cityAr: cityAr,
        ApiKey.buildingNumber: buildingNumber,
      },
    );
  }

  // Get parent Child category
  Future<List<ParentChildModel>> getParentChildren(String brandId,
      [String? parentCategory]) async {
    final response = await _api.get(
        Endpoints.getParentChildByBrandId(brandId),
        isFormdata: true,
        queryparametars: parentCategory != null ? {ApiKey.parentCategory: parentCategory} : {});

    return (response as List).map((e) => ParentChildModel.fromJson(e)).toList();
  }

  // Get brand data
  Future<GetBrandDataModel> getBrandData(String brandId) async {
    final response = await _api.get(Endpoints.getBrandData(brandId));
    return GetBrandDataModel.fromjson(response);
  }
}
