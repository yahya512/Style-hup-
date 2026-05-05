import 'package:dx/E-Commerce/cart_screen.dart';
import 'package:dx/E-Commerce/favourite_screen.dart';
import 'package:dx/E-Commerce/home_screen.dart';
import 'package:dx/core/theme/appstyles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TrackOrderScreen extends StatefulWidget {
  const TrackOrderScreen({super.key});
  @override
  State<TrackOrderScreen> createState() {
    return _TrackOrderScreenState();
  }
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
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
            flexibleSpace: FlexibleSpaceBar(
              title: Text("track_order.to_receive".tr(), style: AppStyles.mainTitleStyle),
              titlePadding: EdgeInsetsDirectional.only(start: 80.w, bottom: 10.h),
            ),
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop(context);
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
          SliverPadding(
            padding: EdgeInsetsDirectional.all(16.dg),
            sliver: SliverToBoxAdapter(
              child: Column(
                spacing: 30.h,
                children: [
                  Center(
                    heightFactor: 2,
                    child: Text(
                      "track_order.track_your_order".tr(),
                      style: AppStyles.subTitleStyle,
                    ),
                  ),
                  // Tracking Number
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0XFFE8E8E8),
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(20.r),
                        right: Radius.circular(20.r),
                      ),
                    ),
                    child: ListTile(
                      isThreeLine: true,
                      title: Text(
                        "track_order.tracking_number".tr(),
                        style: AppStyles.normalTextStyle,
                      ),
                      subtitle: Text(
                        "+201140116154",
                        style: AppStyles.normalTextStyle,
                      ),
                      trailing: Icon(Icons.menu, color: Color(0XFF32DBE6)),
                    ),
                  ),
                  // Packed
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0XFFF9F9F9),
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(20.r),
                        right: Radius.circular(20.r),
                      ),
                    ),
                    child: ListTile(
                      isThreeLine: true,
                      title: Text("track_order.packed".tr(), style: AppStyles.normalTextStyle),
                      subtitle: Text(
                        "track_order.packed_subtitle".tr(),
                        style: AppStyles.normalTextStyle,
                      ),
                      trailing: Text("April,19 12:31"),
                    ),
                  ),
                  // On the Way to Logistic Facility
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0XFFF9F9F9),
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(20.r),
                        right: Radius.circular(20.r),
                      ),
                    ),
                    child: ListTile(
                      isThreeLine: true,
                      title: Text(
                        "track_order.on_the_way".tr(),
                        style: AppStyles.normalTextStyle,
                      ),
                      subtitle: Text(
                        "track_order.on_the_way_subtitle".tr(),
                        style: AppStyles.normalTextStyle,
                      ),
                      trailing: Text("April,19 12:31"),
                    ),
                  ),
                  // Arrived at Logistic Facility
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0XFFF9F9F9),
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(20.r),
                        right: Radius.circular(20.r),
                      ),
                    ),
                    child: ListTile(
                      isThreeLine: true,
                      title: Text(
                        "track_order.arrived".tr(),
                        style: AppStyles.normalTextStyle,
                      ),
                      subtitle: Text(
                        "track_order.arrived_subtitle".tr(),
                        style: AppStyles.normalTextStyle,
                      ),
                      trailing: Text("April,19 12:31"),
                    ),
                  ),
                  // Shipped
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0XFFF9F9F9),
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(20.r),
                        right: Radius.circular(20.r),
                      ),
                    ),
                    child: ListTile(
                      isThreeLine: true,
                      title: Text("track_order.shipped".tr(), style: AppStyles.normalTextStyle),
                      subtitle: Text(
                        "track_order.shipped_subtitle".tr(),
                        style: AppStyles.normalTextStyle,
                      ),
                      trailing: Text("April,19 12:31"),
                    ),
                  ),
                  // Out for Delivery
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0XFFF9F9F9),
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(20.r),
                        right: Radius.circular(20.r),
                      ),
                    ),
                    child: ListTile(
                      isThreeLine: true,
                      title: Text(
                        "track_order.out_for_delivery".tr(),
                        style: AppStyles.normalTextStyle,
                      ),
                      subtitle: Text(
                        "track_order.out_for_delivery_subtitle".tr(),
                        style: AppStyles.normalTextStyle,
                      ),
                      trailing: Text("April,19 12:31"),
                    ),
                  ),
                  // Delivered
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0XFFF9F9F9),
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(20.r),
                        right: Radius.circular(20.r),
                      ),
                    ),
                    child: ListTile(
                      isThreeLine: true,
                      title: Row(
                        spacing: 10.w,
                        children: [
                          Text("track_order.delivered".tr(), style: AppStyles.normalTextStyle),
                          Icon(Icons.check_box, color: Color(0XFF32DBE6)),
                        ],
                      ),
                      subtitle: Text(
                        "track_order.delivered_subtitle".tr(),
                        style: AppStyles.normalTextStyle,
                      ),
                      trailing: Text("April,19 12:31"),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: ElevatedButton(
                      style: AppStyles.commerceButton,
                      child: Text(
                        "track_order.continue_shopping".tr(),
                        style: AppStyles.whiteTextButtonStyle,
                      ),
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                          (route) => false,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
