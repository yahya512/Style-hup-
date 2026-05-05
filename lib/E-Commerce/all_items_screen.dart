import 'package:dx/core/theme/appstyles.dart';
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
        slivers: [
          SliverAppBar(
            flexibleSpace: FlexibleSpaceBar(
              title: Text("all_items.title".tr(), style: AppStyles.mainTitleStyle),
              titlePadding: EdgeInsetsDirectional.only(start: 80.w, bottom: 10.h),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_ios_new),
            ),
          ),

          // Items
        ],
      ),
    );
  }
}
