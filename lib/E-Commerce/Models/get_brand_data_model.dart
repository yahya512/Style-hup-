import 'package:dx/core/api/endpoints.dart';

class GetBrandDataModel {
  final String brandName;
  final String brandEmail;
  final String icon;

  GetBrandDataModel(
      {required this.brandName, required this.brandEmail, required this.icon});

  factory GetBrandDataModel.fromjson(Map<String, dynamic> jsonData) {
    return GetBrandDataModel(
        brandName: jsonData[ApiKey.brandName],
        brandEmail: jsonData[ApiKey.brandEmail],
        icon: jsonData[ApiKey.icon]);
  }
}
