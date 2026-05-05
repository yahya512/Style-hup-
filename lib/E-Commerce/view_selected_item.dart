import 'package:dx/core/theme/appstyles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewSelectedItem extends StatefulWidget {
  const ViewSelectedItem({super.key});
  @override
  State<ViewSelectedItem> createState() {
    return _ViewSelectedItem();
  }
}

class _ViewSelectedItem extends State<ViewSelectedItem> {
  bool selectSize = false;
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
              title: Text(
                "product.pants".tr(),
                style: AppStyles.mainTitleStyle,
              ),
              titlePadding: EdgeInsetsDirectional.only(
                bottom: 10.h,
                start: 80.w,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.favorite_border_sharp),
              ),
            ],
          ),

          SliverPadding(
            padding: EdgeInsetsDirectional.all(24.dg),
            sliver: SliverToBoxAdapter(
              child: Column(
                spacing: 30.h,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: Image.asset(
                        "images/Pants.png",
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  Text(
                    "${"product.price".tr()} : 30\$",
                    style: AppStyles.normalTextStyle,
                  ),
                  Text(
                    "${"product.gender".tr()} : ${"product.male".tr()}",
                    style: AppStyles.normalTextStyle,
                  ),
                  Text(
                    "product.description".tr(),
                    style: AppStyles.normalTextStyle,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${"product.sizes".tr()} :",
                        style: AppStyles.normalTextStyle,
                      ),
                      Container(
                        height: 40.h,
                        width: 60.h,
                        decoration: BoxDecoration(
                          border: BoxBorder.all(
                            width: 2,
                            color: selectSize ? Colors.black : Colors.white,
                          ),
                          color: Color(0XFFE8E8E8),
                          shape: BoxShape.rectangle,
                        ),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              selectSize = !selectSize;
                            });
                          },
                          child: Text("XS", style: AppStyles.normalTextStyle),
                        ),
                      ),
                      Container(
                        height: 40.h,
                        width: 60.h,
                        decoration: BoxDecoration(
                          color: Color(0XFFE8E8E8),
                          shape: BoxShape.rectangle,
                        ),
                        child: TextButton(
                          onPressed: () {},
                          child: Text("S", style: AppStyles.normalTextStyle),
                        ),
                      ),
                      Container(
                        height: 40.h,
                        width: 60.h,
                        decoration: BoxDecoration(
                          color: Color(0XFFE8E8E8),
                          shape: BoxShape.rectangle,
                        ),
                        child: TextButton(
                          onPressed: () {},
                          child: Text("M", style: AppStyles.normalTextStyle),
                        ),
                      ),
                      Container(
                        height: 40.h,
                        width: 60.h,
                        decoration: BoxDecoration(
                          color: Color(0XFFE8E8E8),
                          shape: BoxShape.rectangle,
                        ),
                        child: TextButton(
                          onPressed: () {},
                          child: Text("L", style: AppStyles.normalTextStyle),
                        ),
                      ),
                      Container(
                        height: 40.h,
                        width: 60.h,
                        decoration: BoxDecoration(
                          color: Color(0XFFE8E8E8),
                          shape: BoxShape.rectangle,
                        ),
                        child: TextButton(
                          onPressed: () {},
                          child: Text("XL", style: AppStyles.normalTextStyle),
                        ),
                      ),
                    ],
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 30.w,
                      children: [
                        Text(
                          "${"product.color".tr()} : ",
                          style: AppStyles.normalTextStyle,
                        ),
                        Container(
                          height: 25.h,
                          width: 25.w,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Container(
                          height: 25.h,
                          width: 25.w,
                          decoration: BoxDecoration(
                            color: Colors.tealAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Container(
                          height: 25.h,
                          width: 25.w,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Container(
                          height: 25.h,
                          width: 25.w,
                          decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Container(
                          height: 25.h,
                          width: 25.w,
                          decoration: BoxDecoration(
                            color: Colors.deepPurpleAccent,
                            shape: BoxShape.circle,
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
    );
  }
}
