import 'package:dx/E-Commerce/Models/get_product_by_id_model.dart';
import 'package:dx/cache/cache_helper.dart';
import 'package:dx/core/api/endpoints.dart';
import 'package:dx/core/errors/exceptions.dart';
import 'package:dx/core/services/service_locator.dart';
import 'package:dx/core/theme/appstyles.dart';
import 'package:dx/repositories/user_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewSelectedItem extends StatefulWidget {
  final String brandid;
  final String productid;
  const ViewSelectedItem(
      {super.key, required this.brandid, required this.productid});
  @override
  State<ViewSelectedItem> createState() {
    return _ViewSelectedItem();
  }
}

class _ViewSelectedItem extends State<ViewSelectedItem> {
  int _selectedSizeIndex = 0;
  int _selectedColorIndex = 0;
  final PageController _pageController = PageController();

  // API
  final repository = getIt<UserRepository>();
  GetProductByIdModel? product;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProduct();
  }

  Future<void> fetchProduct() async {
    try {
      final response =
          await repository.getProductById(widget.brandid, widget.productid);
      if (!mounted) return;
      setState(() {
        product = response;
        isLoading = false;
      });
    } on ServerException catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        e.errormodel.message,
        style: AppStyles.snackBarStyle,
      )));
    }
  }

  Color _parseColor(String hex) {
    try {
      hex = hex.replaceAll("#", "");
      if (hex.length == 6) {
        hex = "FF$hex";
      }
      return Color(int.parse(hex, radix: 16));
    } catch (e) {
      return Colors.grey;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final name = product != null
        ? (isArabic ? product!.productNameAr : product!.productNameEn)
        : "Loading...";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF800020),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
        title: Text(
          name,
          style: AppStyles.mainTitleStyle.copyWith(
            fontSize: 24.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : _buildProductDetails(context, isArabic),
    );
  }

  Widget _buildProductDetails(BuildContext context, bool isArabic) {
    if (product == null) {
      return Center(child: Text("Failed to load product"));
    }

    // Dynamic Lists based on product and color index
    final colorDetailsList = product!.colorDetails;
    // ensure _selectedColorIndex is within bounds
    if (_selectedColorIndex >= colorDetailsList.length) {
      _selectedColorIndex = 0;
    }

    List<String> currentImages = [];
    List<VariantsDetailsModel> currentVariants = [];
    ColorDetailsModel? selectedColorDetail;

    if (colorDetailsList.isNotEmpty) {
      selectedColorDetail = colorDetailsList[_selectedColorIndex];
      currentImages = selectedColorDetail.colorImages;
      if (currentImages.isEmpty) {
        currentImages = [product!.thumbnail];
      }
      currentVariants = selectedColorDetail.variantsDetailsDtos;
    } else {
      currentImages = [product!.thumbnail];
    }

    // ensure _selectedSizeIndex is within bounds
    if (_selectedSizeIndex >= currentVariants.length) {
      _selectedSizeIndex = 0;
    }

    final price = currentVariants.isNotEmpty
        ? currentVariants[_selectedSizeIndex].price.toStringAsFixed(2)
        : "0.00";
    final description = isArabic
        ? product!.productDescriptionAr
        : product!.productDescriptionEn;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Images Slider
          Container(
            height: 450.h,
            width: double.infinity,
            color: const Color(0xFFF0F0F0), // Grey background for images
            child: PageView.builder(
              controller: _pageController,
              itemCount: currentImages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: Image.network(
                    currentImages[index],
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[200],
                      child: Icon(Icons.image_not_supported,
                          color: Colors.grey, size: 50.dg),
                    ),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: EdgeInsets.all(24.dg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Price Section
                Text(
                  "${"product.price".tr()}: $price\$",
                  style: AppStyles.mainTitleStyle.copyWith(fontSize: 20.sp),
                ),
                SizedBox(height: 8.h),

                // Rating Section
                Row(
                  children: [
                    ...List.generate(5, (index) {
                      return Icon(
                        index < product!.avgRating.floor()
                            ? Icons.star
                            : (index < product!.avgRating
                                ? Icons.star_half
                                : Icons.star_border),
                        color: Colors.amber,
                        size: 20.dg,
                      );
                    }),
                    SizedBox(width: 8.w),
                    Text(
                      "(${product!.avgRating})",
                      style: AppStyles.normalTextStyle.copyWith(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // Description Section
                Text(
                  description,
                  style: AppStyles.normalTextStyle.copyWith(
                    fontSize: 16.sp,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 24.h),

                // Sizes Selector
                if (currentVariants.isNotEmpty)
                  Row(
                    children: [
                      Text(
                        "${"product.sizes".tr()}: ",
                        style: AppStyles.normalTextStyle.copyWith(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children:
                                List.generate(currentVariants.length, (index) {
                              final isSelected = _selectedSizeIndex == index;
                              return GestureDetector(
                                onTap: () =>
                                    setState(() => _selectedSizeIndex = index),
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12.w, vertical: 6.h),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.grey[300]
                                        : Colors.grey[100],
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                  child: Text(
                                    currentVariants[index].size,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    ],
                  ),
                if (currentVariants.isNotEmpty) SizedBox(height: 20.h),

                // Colors Selector
                if (colorDetailsList.isNotEmpty)
                  Row(
                    children: [
                      Text(
                        "${"product.color".tr()}s: ",
                        style: AppStyles.normalTextStyle.copyWith(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children:
                            List.generate(colorDetailsList.length, (index) {
                          final isSelected = _selectedColorIndex == index;
                          final cCode = colorDetailsList[index].colorCode;
                          final parsedColor = _parseColor(cCode);

                          return GestureDetector(
                            onTap: () => setState(() {
                              _selectedColorIndex = index;
                              _selectedSizeIndex = 0;
                            }),
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 6.w),
                              padding: EdgeInsets.all(2.dg),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.black
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Container(
                                width: 24.w,
                                height: 24.w,
                                decoration: BoxDecoration(
                                  color: parsedColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),

                SizedBox(height: 40.h),

                // Add to Cart Button
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    height: 55.h,
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          final variantId = currentVariants.isNotEmpty
                              ? currentVariants[_selectedSizeIndex].productVariantId
                              : null;
                          final response = await repository.addToCart(
                              widget.brandid, "1", variantId);
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                            response,
                            style: AppStyles.snackBarStyle,
                          )));
                        } on ServerException catch (e) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                            e.errormodel.message,
                            style: AppStyles.snackBarStyle,
                          )));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF800020),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        "product.add_to_cart".tr(),
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
