import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cheering/core/theme/app_theme.dart';
import 'package:cheering/core/theme/app_theme_colors.dart';

class HomeFeedLoadingWidget extends StatelessWidget {
  const HomeFeedLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.colors.borderSecondary,
      highlightColor: context.colors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Categories shimmer
          SizedBox(
            height: 98.h,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              separatorBuilder: (context, index) => SizedBox(width: 12.w),
              itemBuilder: (context, index) => Column(
                children: [
                  Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(width: 50.w, height: 12.h, color: Colors.white),
                ],
              ),
            ),
          ),
          SizedBox(height: 30.h),

          // Deals title shimmer
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Container(width: 150.w, height: 20.h, color: Colors.white),
          ),
          SizedBox(height: 16.h),

          // Deals shimmer
          SizedBox(
            height: 228.h,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              separatorBuilder: (context, index) => SizedBox(width: 12.w),
              itemBuilder: (context, index) => Container(
                width: 280.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
