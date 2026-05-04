import 'package:dx/E-Commerce/cart_screen.dart';
import 'package:dx/E-Commerce/favourite_screen.dart';
import 'package:dx/E-Commerce/home_screen.dart';
import 'package:dx/core/theme/appstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _ShopeScreenState();
  }
}

// number of item from API
List<Map<String, String>> images = [
  {"name": "Hoodies", "image": "images/Hoodies.png", "price": "\$200"},
  {"name": "Pants", "image": "images/Pants.png", "price": "\$300"},
  {"name": "PoloShirt", "image": "images/PoloShirt.png", "price": "\$400"},
  {"name": "Scirts", "image": "images/Scirts.png", "price": "\$150"},
  {"name": "Dress_2x", "image": "images/Dress_2x.png", "price": "\$500"},
  {"name": "Shorts", "image": "images/Shorts.png", "price": "\$800"},
  {"name": "Jackets", "image": "images/Jackets.png", "price": "\$100"},
];

class _ShopeScreenState extends State<ShopScreen> {
  late List<bool> cardFavourite;

  int selectedIcon = 1;

  @override
  void initState() {
    cardFavourite = List.generate(images.length, (i) => false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          //Sliver App Bar
          SliverAppBar(
            pinned: false, //default AppBar (disappear when scroll down)
            floating: true, //appear when scroll up
            snap: true, //It appears immediately, not gradually
            expandedHeight: 50.h,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("Shop", style: AppStyles.mainTitleStyle),
              titlePadding: EdgeInsets.only(left: 80.w, bottom: 10.h),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                  (route) => false,
                );
              },
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

          SliverToBoxAdapter(
            child: Container(
              height: 48.h,
              margin: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: InkWell(
                onTap: () {
                  showSearch(context: context, delegate: CustomSearch());
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 18.w),
                            child: Text(
                              "Search",
                              style: AppStyles.labelTextStyle,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(right: 10).w,
                            child: Icon(Icons.search_outlined, size: 32.dg),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          //Sliver Padding , Silver Grid
          SliverPadding(
            padding: EdgeInsets.all(12.dg),
            sliver: SliverGrid.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20.h,
                crossAxisSpacing: 20.w,
                childAspectRatio: 0.75,
              ),
              itemCount: cardFavourite.length,
              itemBuilder: (context, index) {
                //Items
                return InkWell(
                  onTap: () {},
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(30.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image
                        Expanded(
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 35).h,
                                    child: Column(
                                      spacing: 20.h,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(12.r),
                                          ),
                                          child: Image.asset(
                                            images[index]["image"]!,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        Text(
                                          "${images[index]["name"]}",
                                          style: AppStyles.normalTextStyle,
                                        ),
                                        Text(
                                          "\$250",
                                          style: AppStyles.normalTextStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // Discount
                              Positioned(
                                top: 8.h,
                                left: 8.w,
                                child: Text("50% off"),
                              ),

                              // Favourite Icone
                              Positioned(
                                top: 0.2.h,
                                right: 4.w,
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      cardFavourite[index] =
                                          !cardFavourite[index];
                                    });
                                  },
                                  icon: cardFavourite[index]
                                      ? Icon(
                                          Icons.favorite,
                                          color: Color(0XFF32DBE6),
                                        )
                                      : Icon(Icons.favorite_border),
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
        ],
      ),
      // Bottom Icons
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIcon,
        selectedItemColor: Color(0xFF32DBE6),
        onTap: (value) {
          setState(() {
            selectedIcon = value;
            if (selectedIcon == 0) {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => HomeScreen()));
            } else if (selectedIcon == 2) {
              // Navigator.of(
              //   context,
              // ).push(MaterialPageRoute(builder: (context) => DashBoard()));
            }
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: "Shop",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: "Dashboard",
          ),
        ],
      ),
    );
  }
}
