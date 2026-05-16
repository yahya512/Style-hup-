// ignore_for_file: deprecated_member_use

import 'package:dx/E-Commerce/Models/all_products_list_model.dart';
import 'package:dx/E-Commerce/Models/get_brand_data_model.dart';
import 'package:dx/E-Commerce/Screens/all_items_screen.dart';
import 'package:dx/E-Commerce/Screens/cart_screen.dart';
import 'package:dx/E-Commerce/Screens/favourite_screen.dart';
import 'package:dx/E-Commerce/Screens/setting_screen.dart';
import 'package:dx/E-Commerce/Screens/view_selected_item.dart';
import 'package:dx/cache/cache_helper.dart';
import 'package:dx/core/api/endpoints.dart';
import 'package:dx/core/errors/exceptions.dart';
import 'package:dx/core/services/service_locator.dart';
import 'package:dx/core/theme/appstyles.dart';
import 'package:dx/repositories/user_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
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
    super.initState();
  }

  // Future<GetBrandDataModel?> _brandData() async {
  //   final response = await repository.getBrandData();
  //   brandData = response;
  // }

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
      if (!context.mounted) return;
      setState(() {
        data.addAll(newitems);
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
                    MaterialPageRoute(builder: (context) => FavouriteScreen()),
                  );
                },
                icon: Icon(Icons.favorite_border),
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
                        child: Image.asset(
                          height: 50.h,
                          width: 50.w,
                          "images/Nike.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text(
                        "home.nike".tr(),
                        style: AppStyles.subTitleStyle,
                      ),
                    ],
                  ),
                  Text(
                    "${"home.hello".tr()} ${CacheHelper().getData(key: ApiKey.firstName) ?? "empty"}",
                    style: AppStyles.subTitleStyle,
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
                      showSearch(context: context, delegate: CustomSearch());
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
                          builder: (context) => AllItemsScreen(),
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
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => ViewSelectedItem(
                                              brandid:
                                                  "bee53d22-d94d-4d21-829b-267a011f6921",
                                              productid:
                                                  data[index].productId)));
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
        ],
      ),

      // Bottom Icons
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIcon,
        backgroundColor: const Color(0xFF800020),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        onTap: (value) {
          setState(() {
            _selectedIcon = value;
            if (_selectedIcon == 1) {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => AllItemsScreen()));
            } else if (_selectedIcon == 2) {
              // Navigator.of(
              //   context,
              // ).push(MaterialPageRoute(builder: (context) => DashBoard()));
            } else if (_selectedIcon == 3) {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => SettingEcommerce()),
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

class CustomSearch extends SearchDelegate {
  // list items from API
  List names = [
    "yahya",
    "zaid",
    "mohamed",
    "aly",
    "mostafa",
    "adham",
    "yasser",
    "shady",
    "ibrahim",
    "omar",
    "ahmed",
    "abdulla",
    "gazer",
    "darwish",
    "bahaa",
    "mahmoud",
    "moomen",
    "youssef",
  ];
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = ""; // clear the field
        },
        icon: Icon(Icons.close_rounded),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back_ios_new, size: 25),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Card(child: Text(query, style: AppStyles.mainTitleStyle));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // field isEmpty return all the list
    if (query == "") {
      return ListView.builder(
        itemCount: names.length,
        itemBuilder: (BuildContext context, int i) {
          return InkWell(
            onTap: () {
              showResults(context);
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Text("${names[i]}", style: AppStyles.subTitleStyle),
              ),
            ),
          );
        },
      );
    }
    // return suggestion based on character you typed
    else {
      // element.contains => any name contain the character will appear
      final suggestion = names
          .where(
            (element) => element.toLowerCase().startsWith(query.toLowerCase()),
          )
          .toList();
      return ListView.builder(
        itemCount: suggestion.length,
        itemBuilder: (BuildContext context, int i) {
          return InkWell(
            onTap: () {
              showResults(context);
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Text("${suggestion[i]}", style: AppStyles.subTitleStyle),
              ),
            ),
          );
        },
      );
    }
  }
}
