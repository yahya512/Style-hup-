import 'package:dx/core/theme/appstyles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewSelectedItem extends StatefulWidget {
  const ViewSelectedItem({super.key});
  @override
  State<ViewSelectedItem> createState() {
    return _ViewSelectedItem();
  }
}

class _ViewSelectedItem extends State<ViewSelectedItem> {
  int _selectedSizeIndex = 0;
  int _selectedColorIndex = 0;
  final PageController _pageController = PageController();

  // Placeholder data - TODO: Connect Product Details API response here later
  final List<String> _placeholderImages = [
    "images/Pants.png",
    "images/Hoodies.png",
    "images/RedDress.png",
  ];

  final List<String> _sizes = ["XS", "S", "M", "L", "XL"];
  final List<Color> _colors = [
    const Color(0xFF5A0C1D), // Dark Red/Burgundy from reference
    Colors.black,
    Colors.teal,
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          "Ann dress", // TODO: Fetch real product name from API
          style: AppStyles.mainTitleStyle.copyWith(
            fontSize: 24.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
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
                itemCount: _placeholderImages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Image.asset(
                      _placeholderImages[index],
                      fit: BoxFit.contain,
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
                    // TODO: Fetch real price from API response
                    "${"product.price".tr()}: 30\$",
                    style: AppStyles.mainTitleStyle.copyWith(fontSize: 20.sp),
                  ),
                  SizedBox(height: 8.h),

                  // Rating Section
                  Row(
                    children: [
                      // TODO: Fetch real avgRating from API response
                      ...List.generate(5, (index) {
                        return Icon(
                          index < 3
                              ? Icons.star
                              : Icons.star_border, // Placeholder rating: 3
                          color: Colors.amber,
                          size: 20.dg,
                        );
                      }),
                      SizedBox(width: 8.w),
                      Text(
                        "(3.0)", // Placeholder
                        style: AppStyles.normalTextStyle.copyWith(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  // Gender Section
                  Text(
                    // TODO: Fetch real gender data from API response
                    "${"product.gender".tr()}: ${"product.male".tr()}", // Placeholder shows "Female" in reference, but using localized male/female
                    style: AppStyles.normalTextStyle.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Description Section
                  Text(
                    // TODO: Fetch real description from API response
                    "product.description".tr(),
                    style: AppStyles.normalTextStyle.copyWith(
                      fontSize: 16.sp,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Sizes Selector
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
                            children: List.generate(_sizes.length, (index) {
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
                                    _sizes[index],
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
                  SizedBox(height: 20.h),

                  // Colors Selector
                  Row(
                    children: [
                      Text(
                        "${"product.color".tr()}s: ", // Added 's' as per reference "Colors:"
                        style: AppStyles.normalTextStyle.copyWith(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: List.generate(_colors.length, (index) {
                          final isSelected = _selectedColorIndex == index;
                          return GestureDetector(
                            onTap: () =>
                                setState(() => _selectedColorIndex = index),
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
                                  color: _colors[index],
                                  shape: BoxShape.circle,
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
                        onPressed: () {
                          // TODO: Implement existing Add to Cart logic
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
      ),
    );
  }
}
