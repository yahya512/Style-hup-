import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dx/E-Commerce/Screens/brands_directory_page.dart';
import 'package:dx/E-Commerce/Screens/home_screen.dart';

class VisitStoreButton extends StatelessWidget {
  const VisitStoreButton({super.key, required this.brandId});

  final String brandId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => HomeScreen(brandId: brandId)),
      ),
      child: Container(
        width: double.infinity,
        height: 44.h,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4A0010), Color(0xFF800020)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF800020).withValues(alpha: 0.35),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.storefront_outlined, color: Colors.white, size: 20.r),
            SizedBox(width: 8.w),
            Text(
              'Visit Store',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.6,
              ),
            ),
            SizedBox(width: 6.w),
            Icon(Icons.arrow_forward_ios_rounded,
                color: Colors.white70, size: 12.r),
          ],
        ),
      ),
    );
  }
}

/// Compact pill badge used inside post cards for BRAND-authored posts.
class ShopNowBadge extends StatelessWidget {
  const ShopNowBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const BrandsDirectoryPage()),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4A0010), Color(0xFF800020)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF800020).withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.storefront_outlined, color: Colors.white, size: 13.r),
            SizedBox(width: 4.w),
            Text(
              'Shop',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
