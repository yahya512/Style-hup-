// ignore_for_file: deprecated_member_use

import 'package:dx/E-Commerce/Models/all_products_list_model.dart';
import 'package:dx/E-Commerce/Models/parent_child_model.dart';
import 'package:dx/E-Commerce/Screens/view_selected_item.dart';
import 'package:dx/cache/cache_helper.dart';
import 'package:dx/core/api/endpoints.dart';
import 'package:dx/core/errors/exceptions.dart';
import 'package:dx/core/services/service_locator.dart';
import 'package:dx/core/theme/appstyles.dart';
import 'package:dx/repositories/user_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllItemsScreen extends StatefulWidget {
  const AllItemsScreen({super.key});
  @override
  State<AllItemsScreen> createState() {
    return _AllItemsScreenState();
  }
}

class _AllItemsScreenState extends State<AllItemsScreen> {
  // Api Variables
  final repository = getIt<UserRepository>();

  // Scroll Setup
  late final ScrollController _scrollController;

  // Filter Controllers
  late final TextEditingController minRatingController;
  late final TextEditingController minPriceController;
  late final TextEditingController maxPriceController;
  late final TextEditingController genderController;
  late final TextEditingController categoryIdController;

  bool isLoading = false;
  bool hasMore = true;
  final List<ProductModel> data = [];
  final Map<String, bool> _localFavoriteOverrides = {};
  int currentPage = 0;
  final int pageSize = 10;
  bool _parentHasChildren = false;
  List<ParentChildModel> parentData = [];
  List<ParentChildModel> childData = [];

  @override
  void initState() {
    minRatingController = TextEditingController();
    minPriceController = TextEditingController();
    maxPriceController = TextEditingController();
    genderController = TextEditingController();
    categoryIdController = TextEditingController();

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _loadMoreData();
    super.initState();
  }

  @override
  void dispose() {
    minRatingController.dispose();
    minPriceController.dispose();
    maxPriceController.dispose();
    genderController.dispose();
    categoryIdController.dispose();

    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (isLoading || !hasMore) return;
    if (!_scrollController.hasClients) {
      return; // wait until screen built before use Scrollcontroller
    }
    final pixels = _scrollController.position.pixels;
    final max = _scrollController.position.maxScrollExtent;
    final triggerDistance = 200;

    if (pixels >= (max - triggerDistance)) {
      // call api
      _loadMoreData();
    }
  }

  Future<void> _loadMoreData() async {
    if (isLoading || !hasMore) return;

    setState(() {
      isLoading = true;
    });
    // write API here
    try {
      final response =
          await repository.getAllProductsList(currentPage, pageSize);
      final newitems = response.items;
      hasMore = response.hasNext; // false or true
      setState(() {
        data.addAll(newitems);
        currentPage++;
        isLoading = false;
      });
    } on ServerException catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.errormodel.message,
            style: AppStyles.snackBarStyle,
          ),
        ),
      );
    }
  }

//   Future<void> _fetchParentCategories(
//       void Function(void Function()) setDialogState) async {
//     try {
//       final response = await repository.getParentChildren();
//       setDialogState(() {
//         parentData = response;
//       });
//     } on ServerException catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             e.errormodel.message,
//             style: AppStyles.snackBarStyle,
//           ),
//         ),
//       );
//     }
//   }

//   Future<void> _fetchChildCategories(String parentCategoryNameEn,
//       void Function(void Function()) setDialogState) async {
//     try {
//       final response = await repository.getParentChildren(parentCategoryNameEn);
//       setDialogState(() {
//         childData = response;
//       });
//     } on ServerException catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             e.errormodel.message,
//             style: AppStyles.snackBarStyle,
//           ),
//         ),
//       );
//     }
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            backgroundColor: const Color(0xFF800020),
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              title: Text("all_items.title".tr(),
                  style:
                      AppStyles.mainTitleStyle.copyWith(color: Colors.white)),
              titlePadding:
                  EdgeInsetsDirectional.only(start: 80.w, bottom: 10.h),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_ios_new),
            ),
            actions: [
              IconButton(
                onPressed: _showFilterDialog,
                icon: Icon(Icons.filter_alt_outlined, size: 28.dg),
              ),
            ],
          ),

          // Items
          SliverPadding(
            padding: EdgeInsetsDirectional.all(24.dg),
            sliver: SliverGrid.builder(
                itemCount: data.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16.h,
                  crossAxisSpacing: 16.w,
                  childAspectRatio: 0.72,
                ),
                itemBuilder: (context, index) {
                  final product = data[index];
                  final isArabic = context.locale.languageCode == 'ar';
                  final name =
                      isArabic ? product.productNameAr : product.productNameEn;
                  final detailsText = isArabic ? "التفاصيل" : "Details";
                  final isFavourite =
                      _localFavoriteOverrides[product.productId] ??
                          product.isFavourite;

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Image
                            Expanded(
                              flex: 3,
                              child: ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16.r)),
                                child: Image.network(
                                  product.thumbnail,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    color: Colors.grey[200],
                                    child: Icon(Icons.image_not_supported,
                                        color: Colors.grey),
                                  ),
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      color: Colors.grey[100],
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            // Product Details
                            Padding(
                              padding: EdgeInsets.all(12.dg),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: AppStyles.normalTextStyle
                                        .copyWith(fontSize: 16.sp),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4.h),
                                  GestureDetector(
                                    onTap: () {
                                      //CacheHelper().getData(key: ApiKey.baseUserId)
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ViewSelectedItem(
                                                    brandid:
                                                        "bee53d22-d94d-4d21-829b-267a011f6921",
                                                    productid:
                                                        data[index].productId,
                                                  )));
                                    },
                                    child: Text(
                                      detailsText,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.sp,
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // Favorite Icon
                        Positioned(
                          top: 8.h,
                          right: isArabic ? null : 8.w,
                          left: isArabic ? 8.w : null,
                          child: IconButton(
                            onPressed: () async {
                              if (isFavourite) {
                                // Remove Favorite Condition
                                try {
                                  final response = await repository
                                      .removeFromWishlist(product.productId);
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          content: Text(
                                    response,
                                    style: AppStyles.snackBarStyle,
                                  )));
                                } on ServerException catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        e.errormodel.message,
                                        style: AppStyles.snackBarStyle,
                                      ),
                                    ),
                                  );
                                }
                                _localFavoriteOverrides[product.productId] =
                                    false;
                                setState(() {});
                              } else {
                                // Add To Wishlist Condition
                                try {
                                  final response = await repository
                                      .addToWishlist(product.productId);
                                  _localFavoriteOverrides[product.productId] =
                                      true;
                                  if (!context.mounted) return;
                                  setState(() {});
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        response,
                                        style: AppStyles.snackBarStyle,
                                      ),
                                    ),
                                  );
                                } on ServerException catch (e) {
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        e.errormodel.message,
                                        style: AppStyles.snackBarStyle,
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                            icon: Icon(
                              isFavourite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 24.dg,
                            ),
                            color: isFavourite ? Colors.blue : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ),

          if (isLoading)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          final isArabic = context.locale.languageCode == 'ar';
          // TODO: call parent categories API here to get localized category names (AR/EN)
          if (parentData.isEmpty) {
            // _fetchParentCategories(setDialogState);
          }

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Container(
              padding: EdgeInsets.all(24.dg),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "all_items.filter".tr(),
                          style: AppStyles.mainTitleStyle
                              .copyWith(fontSize: 22.sp),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(Icons.close),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    _buildFilterField(
                      label: "all_items.min_rating".tr(),
                      controller: minRatingController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          if (newValue.text.isEmpty) return newValue;
                          final int? val = int.tryParse(newValue.text);
                          if (val == null || val < 1 || val > 5)
                            return oldValue;
                          return newValue;
                        }),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Expanded(
                          child: _buildFilterField(
                            label: "all_items.min_price".tr(),
                            controller: minPriceController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildFilterField(
                            label: "all_items.max_price".tr(),
                            controller: maxPriceController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    // Gender Dropdown
                    DropdownButtonFormField<String>(
                      value: genderController.text.isEmpty
                          ? null
                          : genderController.text,
                      decoration: InputDecoration(
                        labelText: "all_items.gender".tr(),
                        labelStyle:
                            TextStyle(color: Colors.grey[600], fontSize: 14.sp),
                        filled: true,
                        fillColor: Colors.grey[50],
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 14.h),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: "m",
                          child: Text("gender.male".tr()),
                        ),
                        DropdownMenuItem(
                          value: "f",
                          child: Text("gender.female".tr()),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          genderController.text = value;
                        }
                      },
                    ),
                    SizedBox(height: 12.h),
                    // Category Dropdown
                    DropdownButtonFormField<String>(
                      value: categoryIdController.text.isEmpty
                          ? null
                          : categoryIdController.text,
                      decoration: InputDecoration(
                        labelText: "all_items.category".tr(),
                        labelStyle:
                            TextStyle(color: Colors.grey[600], fontSize: 14.sp),
                        filled: true,
                        fillColor: Colors.grey[50],
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 14.h),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      items: parentData.map((category) {
                        return DropdownMenuItem(
                          value: category.categoryNameEN,
                          child: Text(isArabic
                              ? category.categoryNameAr
                              : category.categoryNameEN),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          categoryIdController.text = value;
                          // TODO: call API here to check if selected category has children
                          final selectedCategory = parentData.firstWhere(
                              (element) => element.categoryId == value);
                          setDialogState(() {
                            _parentHasChildren = selectedCategory.hasChildren;
                            if (_parentHasChildren) {
                              // _fetchChildCategories(value, setDialogState);
                            }
                          });
                        }
                      },
                    ),
                    // Conditional Child Category Dropdown
                    if (_parentHasChildren) ...[
                      SizedBox(height: 12.h),
                      // TODO: call child categories API here to populate child category dropdown
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText:
                              isArabic ? "الفئة الفرعية" : "Child Category",
                          labelStyle: TextStyle(
                              color: Colors.grey[600], fontSize: 14.sp),
                          filled: true,
                          fillColor: Colors.grey[50],
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 14.h),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        items: childData.map((category) {
                          return DropdownMenuItem(
                            value: category.categoryId,
                            child: Text(isArabic
                                ? category.categoryNameAr
                                : category.categoryNameEN),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            categoryIdController.text = value;
                          }
                        },
                      ),
                    ],
                    SizedBox(height: 24.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          // Controllers retain the values. Just close the UI.
                          setState(() {
                            data.clear();
                            currentPage = 0;
                            hasMore = true;
                            _parentHasChildren = false;
                          });
                          try {
                            final responseFilter =
                                await repository.getAllProductsList(
                                    currentPage,
                                    pageSize,
                                    categoryIdController.text,
                                    minRatingController.text,
                                    minPriceController.text,
                                    maxPriceController.text,
                                    genderController.text);
                            final newitems = responseFilter.items;
                            hasMore = responseFilter.hasNext; // false or true
                            setState(() {
                              data.addAll(newitems);
                              currentPage++;
                              isLoading = true;
                            });
                          } on ServerException catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                duration: Duration(seconds: 2),
                                content: Text(
                                  e.errormodel.message,
                                  style: AppStyles.snackBarStyle,
                                )));
                          }
                          if (!context.mounted) return;
                          Navigator.of(context).pop();
                          setState(() {
                            categoryIdController.text = "";
                            minRatingController.text = "";
                            minPriceController.text = "";
                            maxPriceController.text = "";
                            genderController.text = "";
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF800020),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                        ),
                        child: Text(
                          "all_items.apply".tr(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Widget _buildFilterField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14.sp),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    );
  }
}
