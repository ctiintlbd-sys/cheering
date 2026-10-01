import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/theme/app_theme_colors.dart';

class ChatLoadingWidget extends StatelessWidget {
  const ChatLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.colors.borderTertiary,
      highlightColor: context.colors.background,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 180.w,
                height: 48.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 140.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 220.w,
                height: 52.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 190.w,
                height: 44.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
