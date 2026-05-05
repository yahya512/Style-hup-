import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dx/core/api/api_client.dart';
import 'package:dx/core/api/endpoints.dart';
import 'package:dx/Social-Media/brand/models/brand_profile_model.dart';

class BrandProfileService {
  Future<BrandProfileModel> getProfile() async {
    final response = await ApiClient.instance.get<Map<String, dynamic>>(
      Endpoints.brandGetProfile,
    );
    return BrandProfileModel.fromJson(response.data!);
  }

  Future<BrandProfileModel> updateProfile(Map<String, dynamic> updates) async {
    final response = await ApiClient.instance.patch<Map<String, dynamic>>(
      Endpoints.brandGetProfile,
      data: updates,
    );
    return BrandProfileModel.fromJson(response.data!);
  }

  Future<void> uploadProfileImage(File image) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        image.path,
        filename: image.path.split('/').last,
      ),
    });
    await ApiClient.instance.post<void>(
      Endpoints.brandUpdateProfileImage,
      data: formData,
    );
  }

  Future<void> deleteAccount() async {
    await ApiClient.instance.delete<void>(Endpoints.brandDeleteAccount);
  }
}
