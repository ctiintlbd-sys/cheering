import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cheering/core/theme/app_theme_colors.dart';

class MenuItemShimmer extends StatelessWidget {
  final int count;

  const MenuItemShimmer({super.key, this.count = 5});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.colors.borderTertiary,
      highlightColor: context.colors.background,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 16.w),
        itemCount: count,
        separatorBuilder: (context, index) => SizedBox(height: 24.w),
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Shimmer
              Container(
                width: 66.r,
                height: 66.r,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              SizedBox(width: 12.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Shimmer
                    Container(
                      width: 180.w,
                      height: 16.w,
                      margin: EdgeInsets.only(bottom: 6.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    
                    // Subtitle Shimmer
                    Container(
                      width: 220.w,
                      height: 12.w,
                      margin: EdgeInsets.only(bottom: 12.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),

                    // Price & Button Shimmer Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Price
                        Container(
                          width: 60.w,
                          height: 16.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),

                        // Quantity Button Shimmer
                        Container(
                          width: 60.w,
                          height: 28.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(99.r), // rounded pill shape
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
