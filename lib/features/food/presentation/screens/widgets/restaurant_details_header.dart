import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RestaurantDetailsHeader extends StatelessWidget {
  const RestaurantDetailsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      color: context.colors.background,
      topRightRadius: 32.r,
      topLeftRadius: 32.r,
      paddingVertical: 24.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'KFC - Badda',
            fontSize: 20.r,
            fontWeight: FontWeight.w600,
          ).horizontal(16.w),
          SizedBox(height: 4.w),

          CustomText(
            text: 'Fried chicken · Fast food · Combos',
            color: context.colors.textTertiary,
            fontSize: 12.r,
          ).horizontal(16.w),
          SizedBox(height: 8.w),

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
                TextSpan(
                  text: ' 4.5 ',
                  style: TextStyle(color: context.colors.textPrimary),
                ),
                const TextSpan(text: '(27 review) · '),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Icon(
                    Icons.access_time,
                    color: context.colors.iconSecondary,
                    size: 14.r,
                  ),
                ),
                const TextSpan(text: ' 10-20 mins  '),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Icon(
                    Icons.directions_bike,
                    color: context.colors.iconSecondary,
                    size: 14.r,
                  ),
                ),
                const TextSpan(text: '  ৳40 · 1.2Km'),
              ],
            ),
          ).horizontal(16.w),
          SizedBox(height: 12.w),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildTag(
                  context: context,
                  icon: Icons.local_offer_outlined,
                  text: '20% off on orders over ৳500',
                  color: context.colors.primary,
                  bgColor: context.colors.primary.withValues(alpha: 0.1),
                ),
                SizedBox(width: 12.w),
                _buildTag(
                  context: context,
                  icon: Icons.calendar_today_outlined,
                  text: 'Order for Later',
                  color: context.colors.textPrimary,
                  bgColor: context.colors.bgSecondary,
                ),
              ],
            ).horizontal(16.w),
          ),
        ],
      ),
    );
  }

  Widget _buildTag({
    required BuildContext context,
    required IconData icon,
    required String text,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14.r),
          SizedBox(width: 6.w),
          CustomText(
            text: text,
            color: color,
            fontSize: 12.r,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
