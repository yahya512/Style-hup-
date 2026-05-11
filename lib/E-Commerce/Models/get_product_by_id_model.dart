import 'package:dx/core/api/endpoints.dart';

class GetProductByIdModel {
  final String thumbnail;
  final String productNameEn;
  final String productNameAr;
  final String productDescriptionEn;
  final String productDescriptionAr;
  final List<ColorDetailsModel> colorDetails;
  final num avgRating;
  GetProductByIdModel(
      {required this.thumbnail,
      required this.productNameEn,
      required this.productNameAr,
      required this.productDescriptionEn,
      required this.productDescriptionAr,
      required this.colorDetails,
      required this.avgRating});

  factory GetProductByIdModel.fromJson(Map<String, dynamic> jsonData) {
    return GetProductByIdModel(
        thumbnail: jsonData[ApiKey.thumbnail] ?? "",
        productNameEn: jsonData[ApiKey.productNameEn] ?? "",
        productNameAr: jsonData[ApiKey.productNameAr] ?? "",
        productDescriptionEn: jsonData[ApiKey.productDescriptionEn] ?? "",
        productDescriptionAr: jsonData[ApiKey.productDescriptionAr] ?? "",
        colorDetails: (jsonData[ApiKey.colorDetails] as List<dynamic>? ?? [])
            .map((e) => ColorDetailsModel.fromJson(e))
            .toList(),
        avgRating: jsonData[ApiKey.avgRating] ?? 0);
  }
}

class ColorDetailsModel {
  final String productColorId;
  final String colorCode;
  final List<String> colorImages;
  final List<VariantsDetailsModel> variantsDetailsDtos;
  ColorDetailsModel(
      {required this.productColorId,
      required this.colorCode,
      required this.colorImages,
      required this.variantsDetailsDtos});

  factory ColorDetailsModel.fromJson(Map<String, dynamic> jsonData) {
    return ColorDetailsModel(
        productColorId: jsonData[ApiKey.productColorId] ?? "",
        colorCode: jsonData[ApiKey.colorCode] ?? "",
        colorImages: List<String>.from(jsonData[ApiKey.colorImages] ?? []),
        variantsDetailsDtos:
            (jsonData[ApiKey.variantsDetailsDtos] as List<dynamic>? ?? [])
                .map((e) => VariantsDetailsModel.fromJson(e))
                .toList());
  }
}

class VariantsDetailsModel {
  final String productVariantId;
  final String size;
  final String sku;
  final int stock;
  final num price;

  VariantsDetailsModel(
      {required this.productVariantId,
      required this.size,
      required this.sku,
      required this.stock,
      required this.price});

  factory VariantsDetailsModel.fromJson(Map<String, dynamic> jsonData) {
    return VariantsDetailsModel(
        productVariantId: jsonData[ApiKey.productVariantId] ?? "",
        size: jsonData[ApiKey.size] ?? "",
        sku: jsonData[ApiKey.sku] ?? "",
        stock: jsonData[ApiKey.stock] ?? 0,
        price: jsonData[ApiKey.price] ?? 0);
  }
}
