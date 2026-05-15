// ignore_for_file: deprecated_member_use

import 'package:dx/E-Commerce/Models/all_products_list_model.dart';
import 'package:dx/E-Commerce/Screens/cart_screen.dart';
import 'package:dx/core/errors/exceptions.dart';
import 'package:dx/core/services/service_locator.dart';
import 'package:dx/core/theme/appstyles.dart';
import 'package:dx/repositories/user_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});
  @override
  State<FavouriteScreen> createState() {
    return _FavouriteScreenState();
  }
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  // API
  final repository = getIt<UserRepository>();

  // Scroll Setup
  late final ScrollController _scrollController;
  bool isLoading = false;
  bool hasMore = true;
  int currentPage = 0;
  final int pageSize = 10;
  List<ProductModel> data = [];

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
    if (!_scrollController.hasClients) return;

    final pixels = _scrollController.position.pixels;
    final max = _scrollController.position.maxScrollExtent;
    final triggerDistance = 200;

    if (pixels >= (max - triggerDistance)) {
      // call Api
      _loadMoreData();
    }
  }

  Future<void> _loadMoreData() async {
    if (isLoading || !hasMore) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await repository.getWishlist(currentPage, pageSize);
      final newitems = response.items;
      hasMore = response.hasNext;
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
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          //Sliver App Bar
          SliverAppBar(
            pinned: false, //default AppBar (disappear when scroll down)
            floating: true, //appear when scroll up
            snap: true, //It appears immediately, not gradually
            expandedHeight: 50.h,
            backgroundColor: const Color(0xFF800020),
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              title:
                  Text("favourite.title".tr(), style: AppStyles.mainTitleStyle.copyWith(color: Colors.white)),
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
                onPressed: () {},
                icon: Icon(
                  Icons.favorite_border_sharp,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (context) => CartScreen()));
                },
                icon: Icon(Icons.shopping_cart_outlined),
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
                    child: Column(
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
                                      value:
                                          loadingProgress.expectedTotalBytes !=
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
                                onTap: () {},
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
