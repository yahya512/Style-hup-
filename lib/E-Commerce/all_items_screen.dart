import 'package:dx/core/theme/appstyles.dart';
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
          margin: EdgeInsets.only(top: 50.h, left: 20.w),
          child: SingleChildScrollView(
            // Filteration
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(24.dg),
                  child: Column(
                    spacing: 10.h,
                    children: [
                      SizedBox(
                        child: ListTile(
                          title: Text(
                            "Dresses",
                            style: AppStyles.mainTitleStyle,
                          ),
                          trailing: Icon(Icons.navigate_next_sharp, size: 40),
                          onTap: () {},
                        ),
                      ),
                      SizedBox(
                        child: ListTile(
                          title: Text(
                            "Dresses",
                            style: AppStyles.mainTitleStyle,
                          ),
                          trailing: Icon(Icons.navigate_next_sharp, size: 40),
                          onTap: () {},
                        ),
                      ),
                      SizedBox(
                        child: ListTile(
                          title: Text(
                            "Dresses",
                            style: AppStyles.mainTitleStyle,
                          ),
                          trailing: Icon(Icons.navigate_next_sharp, size: 40),
                          onTap: () {},
                        ),
                      ),
                      SizedBox(
                        child: ListTile(
                          title: Text(
                            "Dresses",
                            style: AppStyles.mainTitleStyle,
                          ),
                          trailing: Icon(Icons.navigate_next_sharp, size: 40),
                          onTap: () {},
                        ),
                      ),
                      SizedBox(
                        child: ListTile(
                          title: Text(
                            "Dresses",
                            style: AppStyles.mainTitleStyle,
                          ),
                          trailing: Icon(Icons.navigate_next_sharp, size: 40),
                          onTap: () {},
                        ),
                      ),
                      SizedBox(
                        child: ListTile(
                          title: Text(
                            "Dresses",
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
              title: Text("ALL Items", style: AppStyles.mainTitleStyle),
              titlePadding: EdgeInsets.only(left: 80.w, bottom: 10.h),
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
