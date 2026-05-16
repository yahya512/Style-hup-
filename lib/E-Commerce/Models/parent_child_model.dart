import 'package:dx/core/api/endpoints.dart';

class ParentChildModel {
  final String categoryId;
  final String categoryNameEN;
  final String categoryNameAr;
  final bool hasChildren;

  ParentChildModel(
      {required this.categoryId,
      required this.categoryNameEN,
      required this.categoryNameAr,
      required this.hasChildren});

  factory ParentChildModel.fromJson(Map<String, dynamic> jsonData) {
    return ParentChildModel(
        categoryId: jsonData[ApiKey.categoryId] ?? "",
        categoryNameEN: jsonData[ApiKey.categoryNameEN] ?? "",
        categoryNameAr: jsonData[ApiKey.categoryNameAr] ?? "",
        hasChildren: jsonData[ApiKey.hasChildren] ?? false);
  }
}
