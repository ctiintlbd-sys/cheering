import 'package:cheering/core/theme/app_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class OrderDetailsLoadingWidget extends StatelessWidget {
  const OrderDetailsLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.colors.borderTertiary,
      highlightColor: context.colors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _box(height: 180.w),
          SizedBox(height: 20.w),
          _box(width: 110.w, height: 16.w),
          SizedBox(height: 12.w),
          _box(height: 100.w),
          SizedBox(height: 20.w),
          _box(width: 110.w, height: 16.w),
          SizedBox(height: 12.w),
          _box(height: 160.w),
        ],
      ),
    );
  }

  Widget _box({double? width, required double height}) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
    );
  }
}
