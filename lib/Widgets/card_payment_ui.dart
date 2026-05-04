import 'package:dx/core/theme/appstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//String? _cardHolder, String? _cardNumber, String? _valid
Widget buildCard() {
  return Container(
    height: 140,
    padding: const EdgeInsets.all(12).dg,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16.r),
      gradient: const LinearGradient(
        colors: [Color(0xFFBFD3C1), Color(0xFF6C9A8B)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("ADRBank", style: AppStyles.normalTextStyle),

        const Spacer(),

        Text(
          "4846 6400 8827 7333",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.sp,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),

        const Spacer(),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Card Holder Name", style: AppStyles.normalTextStyle),
                Text(
                  "Yahya Nageh",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Expired Date",
                  style: TextStyle(color: Colors.white54, fontSize: 10),
                ),
                Text("28/3", style: TextStyle(color: Colors.white)),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}
