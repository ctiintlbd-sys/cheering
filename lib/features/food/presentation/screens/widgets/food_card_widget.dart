import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FoodCardWidget extends StatelessWidget {
  const FoodCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          CustomNetworkImage(
            width: 102.w,
            height: 84.w,
            borderRadius: 12.r,
            imageUrl:
                'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38', // Dummy pizza image
          ),
          SizedBox(width: 16.w),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomText(
                        text: 'Pizza House',
                        fontWeight: FontWeight.w600,
                        maxLines: 1,
                      ),
                    ),
                    CustomContainer(
                      paddingAll: 6.r,
                      shape: BoxShape.circle,
                      color: context.colors.bgSecondary,
                      child: Icon(
                        Icons.favorite_border,
                        color: context.colors.primary,
                        size: 16.r,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.w),

                // Subtitle
                CustomText(
                  text: 'Italian · Fast food',
                  color: context.colors.textSecondary,
                  fontSize: 12.r,
                ),
                SizedBox(height: 6.w),

                // Stats Row
                RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 12.r,
                      color: context.colors.textSecondary,
                    ),
                    children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          Icons.star,
                          color: context.colors.ratingColor,
                          size: 14.r,
                        ),
                      ),
                      const TextSpan(text: ' 4.5  ·  '),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          Icons.directions_bike,
                          color: context.colors.iconSecondary,
                          size: 14.r,
                        ),
                      ),
                      const TextSpan(text: ' ৳65(1.5Km)  ·  '),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          Icons.access_time,
                          color: context.colors.iconSecondary,
                          size: 14.r,
                        ),
                      ),
                      const TextSpan(text: ' 10-20 mins'),
                    ],
                  ),
                ),
                SizedBox(height: 10.w),

                // Discount Tag
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.w),
                  decoration: BoxDecoration(
                    color: context.colors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(32.r),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.local_offer_outlined,
                        color: context.colors.primary,
                        size: 12.r,
                      ),
                      CustomText(
                        left: 4.w,
                        text: '20% OFF',
                        color: context.colors.primary,
                        fontSize: 10.r,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
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
