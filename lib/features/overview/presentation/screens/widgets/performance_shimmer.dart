import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class PerformanceShimmer extends StatelessWidget {
  const PerformanceShimmer({super.key});

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
          SizedBox(height: 20.h),
          _buildCalloutShimmer(context),
        ],
      ),
    );
  }

  Widget _buildMetricCardShimmer(BuildContext context) {
    return CustomContainer(
      paddingAll: 16.r,
      radiusAll: 16.r,
      color: context.colors.bgSecondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          SizedBox(height: 6.h),
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
        ],
      ),
    );
  }

  Widget _buildCalloutShimmer(BuildContext context) {
    return CustomContainer(
      width: double.infinity,
      paddingAll: 16.r,
      radiusAll: 16.r,
      color: context.colors.bgSecondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: context.colors.shimmerBase,
            highlightColor: context.colors.shimmerHighlight,
            child: Container(
              width: 180.w,
              height: 18.h,
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
              width: double.infinity,
              height: 14.h,
              decoration: BoxDecoration(
                color: context.colors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Shimmer.fromColors(
            baseColor: context.colors.shimmerBase,
            highlightColor: context.colors.shimmerHighlight,
            child: Container(
              width: 220.w,
              height: 14.h,
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
