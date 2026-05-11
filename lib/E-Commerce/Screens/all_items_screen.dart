// ignore_for_file: deprecated_member_use

import 'package:dx/E-Commerce/Models/all_products_list_model.dart';
import 'package:dx/E-Commerce/Screens/view_selected_item.dart';
import 'package:dx/core/errors/exceptions.dart';
import 'package:dx/core/services/service_locator.dart';
import 'package:dx/core/theme/appstyles.dart';
import 'package:dx/repositories/user_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
  bool isLoading = false;
  bool hasMore = true;
  final List<ProductModel> data = [];
  final Map<String, bool> _localFavoriteOverrides = {};
  int currentPage = 0;
  final int pageSize = 10;
  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _loadMoreData();
    super.initState();
  }

  @override
  void dispose() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: Container(
          margin: EdgeInsetsDirectional.only(top: 50.h, start: 20.w),
          child: SingleChildScrollView(
            // Filteration
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.all(24.dg),
                  child: Column(
                    spacing: 10.h,
                    children: [
                      SizedBox(
                        child: ListTile(
                          title: Text(
                            "all_items.dresses".tr(),
                            style: AppStyles.mainTitleStyle,
                          ),
                          trailing: Icon(Icons.navigate_next_sharp, size: 40),
                          onTap: () {},
                        ),
                      ),
                      SizedBox(
                        child: ListTile(
                          title: Text(
                            "all_items.dresses".tr(),
                            style: AppStyles.mainTitleStyle,
                          ),
                          trailing: Icon(Icons.navigate_next_sharp, size: 40),
                          onTap: () {},
                        ),
                      ),
                      SizedBox(
                        child: ListTile(
                          title: Text(
                            "all_items.dresses".tr(),
                            style: AppStyles.mainTitleStyle,
                          ),
                          trailing: Icon(Icons.navigate_next_sharp, size: 40),
                          onTap: () {},
                        ),
                      ),
                      SizedBox(
                        child: ListTile(
                          title: Text(
                            "all_items.dresses".tr(),
                            style: AppStyles.mainTitleStyle,
                          ),
                          trailing: Icon(Icons.navigate_next_sharp, size: 40),
                          onTap: () {},
                        ),
                      ),
                      SizedBox(
                        child: ListTile(
                          title: Text(
                            "all_items.dresses".tr(),
                            style: AppStyles.mainTitleStyle,
                          ),
                          trailing: Icon(Icons.navigate_next_sharp, size: 40),
                          onTap: () {},
                        ),
                      ),
                      SizedBox(
                        child: ListTile(
                          title: Text(
                            "all_items.dresses".tr(),
                            style: AppStyles.mainTitleStyle,
                          ),
                          trailing: Icon(Icons.navigate_next_sharp, size: 40),
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            flexibleSpace: FlexibleSpaceBar(
              title:
                  Text("all_items.title".tr(), style: AppStyles.mainTitleStyle),
              titlePadding:
                  EdgeInsetsDirectional.only(start: 80.w, bottom: 10.h),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_ios_new),
            ),
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
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ViewSelectedItem()));
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
}
