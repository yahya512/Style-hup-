import 'package:dx/E-Commerce/checkout_screen.dart';
import 'package:dx/E-Commerce/favourite_screen.dart';
import 'package:dx/E-Commerce/shop_screen.dart';
import 'package:dx/core/theme/appstyles.dart';
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
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("Cart", style: AppStyles.mainTitleStyle),
              titlePadding: EdgeInsets.only(bottom: 10.h, left: 80.w),
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
                icon: Icon(Icons.shopping_cart, color: Color(0XFF32DBE6)),
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
            padding: EdgeInsets.all(16.dg),
            sliver: SliverList.builder(
              // in List view
              // shrinkWrap: true, // mange list size depend on items size
              // physics: NeverScrollableScrollPhysics(),
              itemCount: _cartCount.length,
              itemBuilder: (context, index) {
                if (_cartCount[index] == 0) {
                  return SizedBox();
                }
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 16.h),
                  color: Color(0XFFE8E8E8),
                  child: ListTile(
                    isThreeLine: true,
                    leading: Card(
                      child: Image.asset(
                        "${images[index]["image"]}",
                        // "images/Pants.png",
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    title: Text(
                      "black Pants",
                      style: AppStyles.normalTextStyle,
                    ),
                    subtitle: Text(
                      "Size L  ${images[index]["price"]}",
                      style: AppStyles.normalTextStyle,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 5),

                    trailing: Row(
                      spacing: 8.w,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _cartCount[index]++;
                            });
                          },
                          icon: Icon(
                            Icons.add_circle_outline,
                            color: Color(0XFF32DBE6),
                          ),
                        ),

                        Container(
                          color: Color(0XFFE8E8E8),
                          child: Text(
                            "${_cartCount[index]}",
                            style: AppStyles.subTitleStyle,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _cartCount[index]--;
                            });
                          },
                          icon: Icon(
                            Icons.remove_circle_outline,
                            color: Color(0XFF32DBE6),
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
            padding: EdgeInsets.all(16.dg),
            sliver: SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.only(bottom: 20.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.circular(30.r),
                  color: Color(0XFFE8E8E8),
                ),
                height: 60.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Total \$3000", style: AppStyles.normalTextStyle),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0XFF32DBE6),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CheckoutScreen(),
                          ),
                        );
                      },
                      child: Text("Checkout", style: AppStyles.normalTextStyle),
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
