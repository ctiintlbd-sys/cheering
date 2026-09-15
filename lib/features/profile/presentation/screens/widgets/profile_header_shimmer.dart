import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ProfileHeaderShimmer extends StatelessWidget {
  const ProfileHeaderShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      paddingVertical: 8.h,
      paddingHorizontal: 12.w,
      radiusAll: 8.r,
      color: context.colors.bgSecondary,
      child: Row(
        children: [
          Shimmer.fromColors(
            baseColor: context.colors.shimmerBase,
            highlightColor: context.colors.shimmerHighlight,
            child: Container(
              width: 64.r,
              height: 64.r,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: context.colors.shimmerBase,
                  highlightColor: context.colors.shimmerHighlight,
                  child: Container(
                    width: 140.w,
                    height: 16.h,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.h),
                Shimmer.fromColors(
                  baseColor: context.colors.shimmerBase,
                  highlightColor: context.colors.shimmerHighlight,
                  child: Container(
                    width: 180.w,
                    height: 14.h,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
