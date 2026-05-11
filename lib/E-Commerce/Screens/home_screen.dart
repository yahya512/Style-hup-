import 'package:dx/E-Commerce/Screens/all_items_screen.dart';
import 'package:dx/E-Commerce/Screens/cart_screen.dart';
import 'package:dx/E-Commerce/Screens/favourite_screen.dart';
import 'package:dx/E-Commerce/Screens/shop_screen.dart';
import 'package:dx/E-Commerce/Screens/setting_screen.dart';
import 'package:dx/core/theme/appstyles.dart';
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
  //boolean variables
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
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () {},
              icon: Icon(Icons.arrow_back_ios_new),
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
                          "images/avatar_profile2X.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text(
                        "home.mostafa_mahmoud".tr(),
                        style: AppStyles.subTitleStyle,
                      ),
                    ],
                  ),
                  Text(
                    "home.hello_mostafa".tr(),
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
            padding: EdgeInsetsDirectional.all(16.dg),
            sliver: SliverToBoxAdapter(
              child: Column(
                spacing: 30.h,
                children: [
                  // Clothing
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "home.clothing".tr(),
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
                  Wrap(
                    spacing: 32.w,
                    runSpacing: 16.h,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: ClipRRect(
                          borderRadius: BorderRadiusDirectional.circular(20.r),
                          child: Column(
                            children: [
                              Image.asset(
                                "images/Dress_2x.png",
                                fit: BoxFit.contain,
                              ),
                              Text(
                                "home.dress".tr(),
                                style: AppStyles.normalTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: ClipRRect(
                          borderRadius: BorderRadiusDirectional.circular(20.r),
                          child: Column(
                            children: [
                              Image.asset(
                                "images/Pants.png",
                                fit: BoxFit.contain,
                              ),
                              Text(
                                "home.pants".tr(),
                                style: AppStyles.normalTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: ClipRRect(
                          borderRadius: BorderRadiusDirectional.vertical(
                            top: Radius.circular(20),
                            bottom: Radius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Image.asset(
                                "images/Scirts.png",
                                fit: BoxFit.contain,
                              ),
                              Text(
                                "home.scirts".tr(),
                                style: AppStyles.normalTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: ClipRRect(
                          borderRadius: BorderRadiusDirectional.circular(20.r),
                          child: Column(
                            children: [
                              Image.asset(
                                "images/Shorts.png",
                                fit: BoxFit.contain,
                              ),
                              Text(
                                "home.shorts".tr(),
                                style: AppStyles.normalTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: ClipRRect(
                          borderRadius: BorderRadiusDirectional.circular(20.r),
                          child: Column(
                            children: [
                              Image.asset(
                                "images/Hoodies.png",
                                fit: BoxFit.contain,
                              ),
                              Text(
                                "home.hoodies".tr(),
                                style: AppStyles.normalTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: ClipRRect(
                          borderRadius: BorderRadiusDirectional.circular(20.r),
                          child: Column(
                            children: [
                              Image.asset(
                                "images/PoloShirt.png",
                                fit: BoxFit.contain,
                              ),
                              Text(
                                "home.polo_shirt".tr(),
                                style: AppStyles.normalTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
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

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 25.w,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: ClipRRect(
                            borderRadius: BorderRadiusDirectional.circular(
                              20.r,
                            ),
                            child: Column(
                              children: [
                                Image.asset(
                                  "images/Dress_2x.png",
                                  fit: BoxFit.contain,
                                ),
                                Text(
                                  "home.red_dress".tr(),
                                  style: AppStyles.normalTextStyle,
                                ),
                                Text("20\$", style: AppStyles.normalTextStyle),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: ClipRRect(
                            borderRadius: BorderRadiusDirectional.circular(
                              20.r,
                            ),
                            child: Column(
                              children: [
                                Image.asset(
                                  "images/Shirts.png",
                                  fit: BoxFit.contain,
                                ),
                                Text(
                                  "home.shirts".tr(),
                                  style: AppStyles.normalTextStyle,
                                ),
                                Text("20\$", style: AppStyles.normalTextStyle),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: ClipRRect(
                            borderRadius: BorderRadiusDirectional.circular(
                              20.r,
                            ),
                            child: Column(
                              children: [
                                Image.asset(
                                  "images/Hoodies.png",
                                  fit: BoxFit.contain,
                                ),
                                Text(
                                  "home.black_hoodie".tr(),
                                  style: AppStyles.normalTextStyle,
                                ),
                                Text("20\$", style: AppStyles.normalTextStyle),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: ClipRRect(
                            borderRadius: BorderRadiusDirectional.circular(
                              20.r,
                            ),
                            child: Column(
                              children: [
                                Image.asset(
                                  "images/Jackets.png",
                                  fit: BoxFit.contain,
                                ),
                                Text(
                                  "home.modern_jackets".tr(),
                                  style: AppStyles.normalTextStyle,
                                ),
                                Text("20\$", style: AppStyles.normalTextStyle),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Icons
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIcon,
        selectedItemColor: Color(0xFF32DBE6),
        type: BottomNavigationBarType.fixed,
        onTap: (value) {
          setState(() {
            _selectedIcon = value;
            if (_selectedIcon == 1) {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => ShopScreen()));
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
