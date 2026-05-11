import 'package:dx/core/api/endpoints.dart';

class AllProductsListModel {
  final List<ProductModel> items;
  final int page;
  final int size;
  final int totalElements;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  AllProductsListModel(
      {required this.items,
      required this.page,
      required this.size,
      required this.totalElements,
      required this.totalPages,
      required this.hasNext,
      required this.hasPrevious});

  factory AllProductsListModel.fromJson(Map<String, dynamic> jsonData) {
    return AllProductsListModel(
        items: (jsonData[ApiKey.items] as List<dynamic>? ?? [])
            .map((e) => ProductModel.fromJson(e))
            .toList(),
        page: jsonData[ApiKey.page] ?? 0,
        size: jsonData[ApiKey.size] ?? 0,
        totalElements: jsonData[ApiKey.totalElements] ?? 0,
        totalPages: jsonData[ApiKey.totalPages] ?? 0,
        hasNext: jsonData[ApiKey.hasNext] ?? false,
        hasPrevious: jsonData[ApiKey.hasPrevious] ?? false);
  }
}

class ProductModel {
  final String productId;
  final String thumbnail;
  final String productNameEn;
  final String productNameAr;
  final String categoryNameEN;
  final String categoryNameAr;
  final String productDescriptionEn;
  final String productDescriptionAr;
  final num avgRating;
  final int countColorsAvailable;
  final int totalInStock;
  final bool isFavourite;

  ProductModel(
      {required this.productId,
      required this.thumbnail,
      required this.productNameEn,
      required this.productNameAr,
      required this.categoryNameEN,
      required this.categoryNameAr,
      required this.productDescriptionEn,
      required this.productDescriptionAr,
      required this.avgRating,
      required this.countColorsAvailable,
      required this.totalInStock,
      required this.isFavourite});

  factory ProductModel.fromJson(Map<String, dynamic> jsonData) {
    return ProductModel(
        productId: jsonData[ApiKey.productId] ?? "",
        thumbnail: jsonData[ApiKey.thumbnail] ?? "",
        productNameEn: jsonData[ApiKey.productNameEn] ?? "",
        productNameAr: jsonData[ApiKey.productNameAr] ?? "",
        categoryNameEN: jsonData[ApiKey.categoryNameEN] ?? "",
        categoryNameAr: jsonData[ApiKey.categoryNameAr] ?? "",
        productDescriptionEn: jsonData[ApiKey.productDescriptionEn] ?? "",
        productDescriptionAr: jsonData[ApiKey.productDescriptionAr] ?? "",
        avgRating: jsonData[ApiKey.avgRating] ?? 0,
        countColorsAvailable: jsonData[ApiKey.countColorsAvailable] ?? 0,
        totalInStock: jsonData[ApiKey.totalInStock] ?? 0,
        isFavourite: jsonData[ApiKey.isFavourite] ?? false);
  }
}
