import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ReportShimmer extends StatelessWidget {
  const ReportShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildMetricCardShimmer(context)),
              SizedBox(width: 12.w),
              Expanded(child: _buildMetricCardShimmer(context)),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(child: _buildMetricCardShimmer(context)),
              SizedBox(width: 12.w),
              Expanded(child: _buildMetricCardShimmer(context)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCardShimmer(BuildContext context) {
    return CustomContainer(
      paddingAll: 16.r,
      radiusAll: 16.r,
      color: context.colors.bgTertiary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: context.colors.shimmerBase,
            highlightColor: context.colors.shimmerHighlight,
            child: Container(
              width: 90.w,
              height: 14.h,
              decoration: BoxDecoration(
                color: context.colors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Shimmer.fromColors(
            baseColor: context.colors.shimmerBase,
            highlightColor: context.colors.shimmerHighlight,
            child: Container(
              width: 50.w,
              height: 24.h,
              decoration: BoxDecoration(
                color: context.colors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
