import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class OverviewEarningsCardShimmer extends StatelessWidget {
  const OverviewEarningsCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      width: double.infinity,
      color: context.colors.bgSecondary,
      radiusAll: 16,
      bordersColor: context.colors.borderTertiary,
      paddingAll: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Shimmer.fromColors(
            baseColor: context.colors.shimmerBase,
            highlightColor: context.colors.shimmerHighlight,
            child: Container(
              width: 100.w,
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
              width: 140.w,
              height: 28.h,
              decoration: BoxDecoration(
                color: context.colors.white,
                borderRadius: BorderRadius.circular(6.r),
              ),
            ),
          ),
          SizedBox(height: 14.h),
          Container(
            height: 0.8.h,
            width: double.infinity,
            color: context.colors.borderSecondary,
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              3,
              (_) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Shimmer.fromColors(
                    baseColor: context.colors.shimmerBase,
                    highlightColor: context.colors.shimmerHighlight,
                    child: Container(
                      width: 50.w,
                      height: 12.h,
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
                      width: 40.w,
                      height: 16.h,
                      decoration: BoxDecoration(
                        color: context.colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OverviewChartShimmer extends StatelessWidget {
  const OverviewChartShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Shimmer.fromColors(
          baseColor: context.colors.shimmerBase,
          highlightColor: context.colors.shimmerHighlight,
          child: Container(
            width: 90.w,
            height: 12.h,
            decoration: BoxDecoration(
              color: context.colors.white,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 139.h,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(
              7,
              (index) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: index == 6 ? 0 : 10.w),
                  child: Shimmer.fromColors(
                    baseColor: context.colors.shimmerBase,
                    highlightColor: context.colors.shimmerHighlight,
                    child: Container(
                      height: (40 + (index % 4) * 25).h,
                      decoration: BoxDecoration(
                        color: context.colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(8.r),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class OverviewRecentOrdersShimmer extends StatelessWidget {
  const OverviewRecentOrdersShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 16.r,vertical: 0),
      itemCount: 3,
      separatorBuilder: (_, _) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        return CustomContainer(
          width: double.infinity,
          color: context.colors.background,
          radiusAll: 16,
          bordersColor: context.colors.borderTertiary,
          borderWidth: 1,
          paddingHorizontal: 12,
          paddingVertical: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shimmer.fromColors(
                    baseColor: context.colors.shimmerBase,
                    highlightColor: context.colors.shimmerHighlight,
                    child: Container(
                      width: 90.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        color: context.colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Shimmer.fromColors(
                    baseColor: context.colors.shimmerBase,
                    highlightColor: context.colors.shimmerHighlight,
                    child: Container(
                      width: 120.w,
                      height: 16.h,
                      decoration: BoxDecoration(
                        color: context.colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Shimmer.fromColors(
                    baseColor: context.colors.shimmerBase,
                    highlightColor: context.colors.shimmerHighlight,
                    child: Container(
                      width: 55.w,
                      height: 14.h,
                      decoration: BoxDecoration(
                        color: context.colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Shimmer.fromColors(
                    baseColor: context.colors.shimmerBase,
                    highlightColor: context.colors.shimmerHighlight,
                    child: Container(
                      width: 70.w,
                      height: 16.h,
                      decoration: BoxDecoration(
                        color: context.colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
