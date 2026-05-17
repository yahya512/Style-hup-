import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildCard({
  String holder = '',
  String number = '',
  String expiry = '',
}) {
  final maskedNumber = _maskCardNumber(number);

  return Container(
    height: 180.h,
    width: double.infinity,
    padding: EdgeInsets.all(20.dg),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20.r),
      gradient: const LinearGradient(
        colors: [Color(0xFF800020), Color(0xFF2C0A0A)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF800020).withValues(alpha: 0.4),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'StyleHub',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            Container(
              width: 40.w,
              height: 28.h,
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37).withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Icon(Icons.credit_card, color: Colors.white, size: 18.sp),
            ),
          ],
        ),
        const Spacer(),
        Text(
          maskedNumber.isNotEmpty ? maskedNumber : '•••• •••• •••• ••••',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            letterSpacing: 3,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CARD HOLDER',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 9.sp,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  holder.isNotEmpty ? holder.toUpperCase() : '——',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'EXPIRES',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 9.sp,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  expiry.isNotEmpty ? expiry : '——',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

String _maskCardNumber(String raw) {
  final digits = raw.replaceAll(RegExp(r'\D'), '');
  if (digits.length < 4) return '';
  final last4 = digits.substring(digits.length - 4);
  return '•••• •••• •••• $last4';
}
