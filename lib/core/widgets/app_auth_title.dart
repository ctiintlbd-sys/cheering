import 'package:flutter/material.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppAuthTitle extends StatelessWidget {
  const AppAuthTitle({
    super.key,
    required this.subtitle,
    required this.title,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //SizedBox(height: 20.h),
          CustomText(
            text: title,
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.center,
            color: context.colors.textPrimary,
            maxLines: 1,
          ),
          CustomText(
            text: subtitle,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            textAlign: TextAlign.center,
            maxLines: 2,
            color: context.colors.textSecondary,
            top: 8.h,
          ),
        ],
      ),
    );
  }
}
