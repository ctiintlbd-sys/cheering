import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cheering/core/widgets/widgets.dart';

class BusinessHoursShimmer extends StatelessWidget {
  const BusinessHoursShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: 7,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: context.colors.shimmerBase,
          highlightColor: context.colors.shimmerHighlight,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 56.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    // Day Label
                    Container(
                      height: 16.h,
                      width: 40.w,
                      decoration: BoxDecoration(
                        color: context.colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(width: 10.w),

                    // Time range
                    Expanded(
                      child: Container(
                        height: 14.h,
                        margin: EdgeInsets.only(right: 60.w),
                        decoration: BoxDecoration(
                          color: context.colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ),

                    // Toggle Switch Placeholder
                    Container(
                      height: 31.h,
                      width: 51.w,
                      decoration: BoxDecoration(
                        color: context.colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: context.colors.outline.withValues(alpha: 0.5),
                height: 1,
                thickness: 1,
              ),
            ],
          ),
        );
      },
    );
  }
}
