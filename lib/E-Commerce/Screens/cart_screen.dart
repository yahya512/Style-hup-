// ignore_for_file: deprecated_member_use

import 'package:dx/E-Commerce/Screens/checkout_screen.dart';
import 'package:dx/E-Commerce/Screens/favourite_screen.dart';
import 'package:dx/E-Commerce/Screens/shop_screen.dart';
import 'package:dx/core/theme/appstyles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _CartScreenState();
  }
}

class _CartScreenState extends State<CartScreen> {
  // Cart Counter

  final List<int> _cartCount = List.generate(images.length, (i) => 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 0,
            pinned: false, //default AppBar (disappear when scroll down)
            floating: true, //appear when scroll up
            snap: true, //It appears immediately, not gradually
            expandedHeight: 50.h,
            backgroundColor: const Color(0xFF800020),
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              title: Text("cart.title".tr(), style: AppStyles.mainTitleStyle.copyWith(color: Colors.white)),
              titlePadding:
                  EdgeInsetsDirectional.only(bottom: 10.h, start: 80.w),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => FavouriteScreen()),
                  );
                },
                icon: Icon(Icons.favorite_border),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.shopping_cart, color: Colors.white),
              ),
            ],
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_ios_new),
            ),
          ),

          // Cart info
          SliverPadding(
            padding: EdgeInsetsDirectional.all(16.dg),
            sliver: SliverList.builder(
              itemCount: _cartCount.length,
              itemBuilder: (context, index) {
                if (_cartCount[index] == 0) {
                  return const SizedBox();
                }
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12.dg),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Image Container
                        Container(
                          width: 80.w,
                          height: 80.w,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: Image.asset(
                              "${images[index]["image"]}",
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        // Product Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "cart.black_pants".tr(),
                                style: AppStyles.mainTitleStyle.copyWith(
                                  fontSize: 16.sp,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                "${"cart.size".tr()} L",
                                style: AppStyles.normalTextStyle.copyWith(
                                  color: Colors.grey[600],
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                "${images[index]["price"]}",
                                style: AppStyles.mainTitleStyle.copyWith(
                                  fontSize: 16.sp,
                                  color: const Color(0XFF32DBE6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Quantity Controls
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.all(8.dg),
                                onPressed: () {
                                  setState(() {
                                    _cartCount[index]++;
                                  });
                                },
                                icon: Icon(
                                  Icons.add,
                                  color: Colors.black87,
                                  size: 18.sp,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4.w),
                                child: Text(
                                  "${_cartCount[index]}",
                                  style: AppStyles.subTitleStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.all(8.dg),
                                onPressed: () {
                                  setState(() {
                                    _cartCount[index]--;
                                  });
                                },
                                icon: Icon(
                                  Icons.remove,
                                  color: Colors.black87,
                                  size: 18.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          SliverPadding(
            padding: EdgeInsetsDirectional.all(16.dg),
            sliver: SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsetsDirectional.only(bottom: 20.h, top: 10.h),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "cart.total".tr(),
                          style: AppStyles.normalTextStyle.copyWith(
                            color: Colors.grey[600],
                            fontSize: 14.sp,
                          ),
                        ),
                        Text(
                          "\$3000",
                          style: AppStyles.mainTitleStyle.copyWith(
                            fontSize: 20.sp,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF800020),
                        padding: EdgeInsets.symmetric(
                          horizontal: 32.w,
                          vertical: 12.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const CheckoutScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "cart.checkout".tr(),
                        style: AppStyles.mainTitleStyle.copyWith(
                          fontSize: 16.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
