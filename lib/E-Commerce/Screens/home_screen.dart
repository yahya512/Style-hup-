// ignore_for_file: deprecated_member_use

import 'package:dx/E-Commerce/Models/all_products_list_model.dart';
import 'package:dx/E-Commerce/Models/get_brand_data_model.dart';
import 'package:dx/E-Commerce/Screens/all_items_screen.dart';
import 'package:dx/E-Commerce/Screens/product_search_screen.dart';
import 'package:dx/E-Commerce/Screens/cart_screen.dart';
import 'package:dx/E-Commerce/Screens/favourite_screen.dart';
import 'package:dx/E-Commerce/Screens/setting_screen.dart';
import 'package:dx/E-Commerce/Screens/view_selected_item.dart';
import 'package:dx/core/errors/exceptions.dart';
import 'package:dx/core/services/service_locator.dart';
import 'package:dx/core/theme/appstyles.dart';
import 'package:dx/repositories/user_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  final String brandId;
  const HomeScreen({super.key, required this.brandId});
  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  // bottom icons
  int _selectedIcon = 0;
  // Api Variables
  final repository = getIt<UserRepository>();
// Scroll Setup
  late final ScrollController _scrollController;
  bool isLoading = false;
  bool hasMore = true;
  bool _hasError = false;
  String? _errorMessage;
  final List<ProductModel> data = [];
  final Map<String, bool> _localFavoriteOverrides = {};
  int currentPage = 0;
  final int pageSize = 10;
  GetBrandDataModel? brandData;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _loadMoreData();
    _loadBrandData();
    super.initState();
  }

  Future<void> _loadBrandData() async {
    try {
      final result = await repository.getBrandData(widget.brandId);
      if (mounted) setState(() => brandData = result);
    } catch (_) {
      // Brand header is cosmetic — silently ignore failures.
    }
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
      final response = await repository.getAllProductsList(
          widget.brandId, currentPage, pageSize);
      final newitems = response.items;
      hasMore = response.hasNext;
      if (!context.mounted) return;
      setState(() {
        data.addAll(newitems);
        isLoading = false;
        currentPage++;
      });
    } on ServerException catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        if (data.isEmpty) {
          _hasError = true;
          _errorMessage = e.errormodel.message;
        }
      });
      if (data.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.errormodel.message, style: AppStyles.snackBarStyle),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError && data.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF800020),
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.store_mall_directory_outlined,
                    size: 72.r, color: Colors.grey[300]),
                SizedBox(height: 20.h),
                Text(
                  'This brand has no products yet.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  _errorMessage ?? 'Check back later for new arrivals.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[500]),
                ),
                SizedBox(height: 28.h),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF800020),
                    padding:
                        EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r)),
                    elevation: 0,
                  ),
                  child: Text(
                    'Go Back',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

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
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            FavouriteScreen(brandId: widget.brandId)),
                  );
                },
                icon: Icon(Icons.favorite_border),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          CartScreen(brandId: widget.brandId)));
                },
                icon: Icon(Icons.shopping_cart_outlined),
              ),
            ],
          ),
          // Header , SearchBar
          SliverPadding(
            padding: EdgeInsets.all(16.dg),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 10.w,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadiusDirectional.circular(80.r),
                        child: brandData?.icon != null
                            ? Image.network(
                                brandData!.icon,
                                height: 50.h,
                                width: 50.w,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    _BrandIconFallback(),
                              )
                            : _BrandIconFallback(),
                      ),
                      Text(
                        brandData?.brandName ?? '',
                        style: AppStyles.subTitleStyle,
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),
                  InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadiusDirectional.circular(50.r),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5.w,
                              child: Padding(
                                padding: const EdgeInsetsDirectional.all(10),
                                child: Text(
                                  "home.search".tr(),
                                  style: AppStyles.labelTextStyle,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.only(end: 10),
                            child: Icon(Icons.search_outlined, size: 32.dg),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) =>
                            ProductSearchScreen(brandId: widget.brandId),
                      ));
                    },
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: EdgeInsetsDirectional.symmetric(
                horizontal: 16.dg, vertical: 8.h),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "home.all_items".tr(),
                    style: AppStyles.subTitleStyle,
                  ),
                  TextButton(
                    child: Text(
                      "home.see_all".tr(),
                      style: AppStyles.subTitleStyle,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              AllItemsScreen(brandId: widget.brandId),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // show items by using api data
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
                                                  ViewSelectedItem(
                                                      brandid: widget.brandId,
                                                      productid: data[index]
                                                          .productId)));
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
                                  final response =
                                      await repository.removeFromWishlist(
                                          widget.brandId, product.productId);
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
                                  final response =
                                      await repository.addToWishlist(
                                          widget.brandId, product.productId);
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
        ],
      ),

      // Bottom Icons
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIcon,
        backgroundColor: const Color(0xFF800020),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        onTap: (value) async {
          if (value == 2) {
            final Uri url =
                Uri.parse('https://model-dashboard-wine.vercel.app/#/login');
            try {
              if (!await launchUrl(
                url,
                mode: LaunchMode.inAppWebView,
              )) {
                debugPrint('Could not launch $url');
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Could not launch the dashboard website.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              }
            } catch (e) {
              debugPrint('Error launching URL: $e');
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error launching website: $e'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            }
            return;
          }

          setState(() {
            _selectedIcon = value;
            if (_selectedIcon == 1) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      AllItemsScreen(brandId: widget.brandId)));
            } else if (_selectedIcon == 3) {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) =>
                        SettingEcommerce(brandId: widget.brandId)),
              );
            }
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: "nav.home".tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: "nav.shop".tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: "nav.dashboard".tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "nav.settings".tr(),
          ),
        ],
      ),
    );
  }
}

class _BrandIconFallback extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      width: 50.w,
      decoration: const BoxDecoration(
        color: Color(0xFF800020),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.storefront_rounded, color: Colors.white, size: 28.r),
    );
  }
}
