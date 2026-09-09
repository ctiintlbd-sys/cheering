import 'package:cheering/core/utils/assets/fonts.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StoreDetailsHeader extends StatelessWidget {
  const StoreDetailsHeader({super.key, this.onTap, this.isExpanded = false});

  /// Toggles between the menu view and the reviews view.
  final VoidCallback? onTap;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      color: context.colors.background,
      topRightRadius: 32.r,
      topLeftRadius: 32.r,
      paddingVertical: 24.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: 'KFC - Badda',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
                AnimatedRotation(
                  turns: isExpanded ? 0.25 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: Icon(
                    Icons.chevron_right,
                    color: context.colors.iconSecondary,
                    size: 24.r,
                  ),
                ),
              ],
            ),
          ).horizontal(16.w),
          SizedBox(height: 4.h),

          CustomText(
            text: 'Fried chicken · Fast food · Combos',
            color: context.colors.textTertiary,
            fontSize: 12.sp,
          ).horizontal(16.w),
          SizedBox(height: 8.h),

          // Stats Row
          RichText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              style: TextStyle(
                fontSize: 12.sp,
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
          SizedBox(height: 12.h),

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
          SizedBox(height: 24.h),

          _buildRatingSummary(context),
        ],
      ),
    );
  }

  Widget _buildRatingSummary(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: FontFamily.sFPro,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: context.colors.textPrimary,
                    height: 1.7,
                  ),
                  children: [
                    TextSpan(
                      text: '4.3\n',
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const TextSpan(text: '4.3 '),
                    TextSpan(
                      text: '(27)\n27 ratings',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: context.colors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(width: 20.w),
          Expanded(
            child: Column(
              children: [
                _buildRatingBar(context, star: '5', ratio: 1),
                _buildRatingBar(context, star: '4', ratio: 0.8),
                _buildRatingBar(context, star: '3', ratio: 0.6),
                _buildRatingBar(context, star: '2', ratio: 0.4),
                _buildRatingBar(context, star: '1', ratio: 0.2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(
    BuildContext context, {
    required String star,
    required double ratio,
  }) {
    return Row(
      children: [
        CustomText(
          text: star,
          fontSize: 12.sp,
          color: context.colors.textTertiary,
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(99.r),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 6.h,
              backgroundColor: context.colors.borderTertiary,
              valueColor: AlwaysStoppedAnimation<Color>(
                context.colors.ratingColor,
              ),
            ),
          ),
        ),
      ],
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
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
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
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
