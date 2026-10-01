import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cheering/core/widgets/widgets.dart';

class BitesShimmer extends StatelessWidget {
  const BitesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 176.w,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        separatorBuilder: (context, index) => SizedBox(width: 12.w),
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: context.colors.borderTertiary,
            highlightColor: context.colors.background,
            child: Container(
              width: 124.w,
              height: 176.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          );
        },
      ),
    );
  }
}
