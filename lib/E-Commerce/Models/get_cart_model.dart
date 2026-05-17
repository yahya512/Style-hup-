import 'package:dx/core/api/endpoints.dart';

class GetCartModel {
  final String page;
  final String size;
  final String hasNext;
  final List<ProductModel> items;

  GetCartModel(
      {required this.page,
      required this.size,
      required this.hasNext,
      required this.items});

  factory GetCartModel.fromJson(Map<String, dynamic> jsonData) {
    return GetCartModel(
        page: jsonData[ApiKey.page]?.toString() ?? '0',
        size: jsonData[ApiKey.size]?.toString() ?? '0',
        hasNext: jsonData[ApiKey.hasNext]?.toString() ?? 'false',
        items: (jsonData[ApiKey.items] as List<dynamic>? ?? [])
            .map((e) => ProductModel.fromJson(e))
            .toList());
  }
}

class ProductModel {
  final String size;
  final String productId;
  final String thumbnail;
  final String productNameEn;
  final String productNameAr;
  final String cartId;
  final String cartItemId;
  final String cartStatus;
  final String productVariantId;
  final String sku;
  final String colorCode;
  final num totalPrice;
  final num qantity;

  ProductModel(
      {required this.productId,
      required this.thumbnail,
      required this.productNameEn,
      required this.productNameAr,
      required this.size,
      required this.cartId,
      required this.cartItemId,
      required this.cartStatus,
      required this.productVariantId,
      required this.sku,
      required this.colorCode,
      required this.totalPrice,
      required this.qantity});

  factory ProductModel.fromJson(Map<String, dynamic> jsonData) {
    return ProductModel(
      productId: jsonData[ApiKey.productId] ?? "",
      thumbnail: jsonData[ApiKey.thumbnail] ?? "",
      productNameEn: jsonData[ApiKey.productNameEn] ?? "",
      productNameAr: jsonData[ApiKey.productNameAr] ?? "",
      size: jsonData[ApiKey.size] ?? "",
      cartId: jsonData[ApiKey.cartId] ?? "",
      cartItemId: jsonData[ApiKey.cartItemId] ?? "",
      cartStatus: jsonData[ApiKey.cartStatus] ?? "",
      productVariantId: jsonData[ApiKey.productVariantId] ?? "",
      sku: jsonData[ApiKey.sku] ?? "",
      colorCode: jsonData[ApiKey.colorCode] ?? "",
      totalPrice: jsonData[ApiKey.totalPrice] ?? 0,
      qantity: jsonData[ApiKey.quantity] ?? 0,
    );
  }
}
