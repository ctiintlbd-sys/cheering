import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopRestaurantCard extends StatelessWidget {
  const TopRestaurantCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      width: 200.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomContainer(
            width: double.infinity,
            height: 140.h,
            radiusAll: 16.r,
            clipBehavior: Clip.hardEdge,
            child: Stack(
              children: [
                CustomNetworkImage(
                  imageUrl: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4',
                  boxShape: BoxShape.rectangle,
                ),
                Positioned(
                  top: 10.h,
                  right: 10.w,
                  child: CustomContainer(
                    width: 32.r,
                    height: 32.r,
                    radiusAll: 16.r,
                    color: Colors.white.withOpacity(0.8),
                    alignment: Alignment.center,
                    child: Icon(Icons.favorite_border, color: context.colors.iconSecondary, size: 18.r),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          CustomText(
            text: 'KFC - Badda',
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            maxLines: 1,
            textOverflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(Icons.directions_bike, color: context.colors.iconSecondary, size: 14.r),
              SizedBox(width: 4.w),
              CustomText(
                text: '৳40',
                fontSize: 12.sp,
                color: context.colors.textSecondary,
              ),
              SizedBox(width: 6.w),
              CustomText(text: '•', color: context.colors.textSecondary, fontSize: 12.sp),
              SizedBox(width: 6.w),
              CustomText(
                text: '1.2Km',
                fontSize: 12.sp,
                color: context.colors.textSecondary,
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Icon(Icons.star, color: const Color(0xFFFFB300), size: 14.r),
              SizedBox(width: 4.w),
              CustomText(
                text: '4.3 (27)',
                fontSize: 12.sp,
                color: context.colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(width: 6.w),
              CustomText(text: '•', color: context.colors.textSecondary, fontSize: 12.sp),
              SizedBox(width: 6.w),
              Icon(Icons.access_time, color: context.colors.iconSecondary, size: 14.r),
              SizedBox(width: 4.w),
              CustomText(
                text: '15-30 mins',
                fontSize: 12.sp,
                color: context.colors.textSecondary,
              ),
            ],
          )
        ],
      ),
    );
  }
}
