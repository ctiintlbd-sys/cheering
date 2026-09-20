import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cheering/core/widgets/widgets.dart';

class HRestaurantCardShimmer extends StatelessWidget {
  const HRestaurantCardShimmer({super.key, this.count = 4});

  final int count;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 24.w),
      itemCount: count,
      separatorBuilder: (_, __) => SizedBox(height: 4.w),
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
          child: Shimmer.fromColors(
            baseColor: context.colors.borderTertiary,
            highlightColor: context.colors.background,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Shimmer
                Container(
                  width: 102.w,
                  height: 84.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                SizedBox(width: 16.w),

                // Details Shimmer
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 120.w,
                            height: 16.w,
                            color: Colors.white,
                          ),
                          Container(
                            width: 28.r,
                            height: 28.r,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.w),

                      // Subtitle
                      Container(
                        width: 100.w,
                        height: 12.w,
                        color: Colors.white,
                      ),
                      SizedBox(height: 8.w),

                      // Stats Row
                      Container(
                        width: 180.w,
                        height: 12.w,
                        color: Colors.white,
                      ),
                      SizedBox(height: 12.w),

                      // Discount Tag
                      Container(
                        width: 60.w,
                        height: 20.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32.r),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
