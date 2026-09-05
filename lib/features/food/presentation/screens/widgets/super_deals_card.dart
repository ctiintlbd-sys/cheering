import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SuperDealsCard extends StatelessWidget {
  const SuperDealsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      width: 290.w,
      height: 200.h,
      radiusAll: 16.r,
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          CustomNetworkImage(
            imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591',
            boxShape: BoxShape.rectangle,
          ),
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.85),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.7],
              ),
            ),
          ),
          // Top Badges
          Positioned(
            top: 12.h,
            left: 12.w,
            right: 12.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomContainer(
                  radiusAll: 16.r,
                  child: CustomText(
                    text: '20%Off',
                    color: const Color(0xFFE91E63), // Pink text
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                  ),
                ),
                CustomContainer(
                  width: 32.r,
                  height: 32.r,
                  radiusAll: 16.r,
                  color: Colors.black.withOpacity(0.4),
                  alignment: Alignment.center,
                  child: Icon(Icons.favorite_border, color: Colors.white, size: 18.r),
                ),
              ],
            ),
          ),
          // Bottom Info
          Positioned(
            bottom: 14.h,
            left: 12.w,
            right: 12.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomText(
                        text: 'Tandoori Pizza',
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        maxLines: 1,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ),
                    CustomText(
                      text: '৳350',
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                CustomText(
                  text: 'Pizza House • Fast Food',
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12.sp,
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(Icons.star, color: const Color(0xFFFFB300), size: 14.r),
                    SizedBox(width: 4.w),
                    CustomText(text: '4.5', color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w600),
                    SizedBox(width: 6.w),
                    CustomText(text: '•', color: Colors.white.withOpacity(0.5), fontSize: 12.sp),
                    SizedBox(width: 6.w),
                    Icon(Icons.directions_bike, color: Colors.white, size: 14.r),
                    SizedBox(width: 4.w),
                    CustomText(text: '৳65(1.5Km)', color: Colors.white, fontSize: 12.sp),
                    SizedBox(width: 6.w),
                    CustomText(text: '•', color: Colors.white.withOpacity(0.5), fontSize: 12.sp),
                    SizedBox(width: 6.w),
                    Icon(Icons.access_time, color: Colors.white, size: 14.r),
                    SizedBox(width: 4.w),
                    CustomText(text: '10-20 mins', color: Colors.white, fontSize: 12.sp),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
