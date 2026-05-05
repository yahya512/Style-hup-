import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dx/Social-Media/search/models/search_result_model.dart';
import 'package:dx/core/theme/appstyles.dart';

class SearchResultTile extends StatelessWidget {
  const SearchResultTile({
    super.key,
    required this.result,
    required this.onTap,
  });

  final SearchResultModel result;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        radius: 22.r,
        backgroundColor: Colors.grey[200],
        backgroundImage: result.profileImageUrl != null
            ? NetworkImage(result.profileImageUrl!)
            : null,
        child: result.profileImageUrl == null
            ? Icon(
                result.type == AccountType.brand
                    ? Icons.store
                    : Icons.person,
                size: 22.r,
                color: Colors.grey[500],
              )
            : null,
      ),
      title: Text(result.displayName, style: AppStyles.normalTextStyle),
      subtitle: Text(
        '@${result.username}',
        style: TextStyle(fontSize: 12.sp, color: Colors.grey[500]),
      ),
      trailing: result.type == AccountType.brand
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: Colors.teal.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                'Brand',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.teal,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : null,
    );
  }
}
