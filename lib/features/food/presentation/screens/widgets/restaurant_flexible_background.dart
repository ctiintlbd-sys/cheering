import 'package:cheering/features/food/domain/entities/restaurant_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/core/common_widgets/common_details_actions.dart';
import 'package:cheering/features/food/presentation/screens/widgets/restaurant_tags_row.dart';

class RestaurantFlexibleBackground extends StatelessWidget {
  final RestaurantEntity? restaurant;

  const RestaurantFlexibleBackground({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomNetworkImage(
          height: 220.w,
          width: double.maxFinite,
          imageUrl: restaurant?.logoUrl ?? restaurant?.coverImageUrl,
        ),
        Positioned(
          top: 190.w,
          right: 0,
          left: 0,
          child: _buildRestaurantDetailsHeader(context),
        ),
        Positioned(
          top: kToolbarHeight,
          left: 16.w,
          child: CommonActionIcon(
            icon: Assets.icons.arrowBack.path,
            onTap: () => context.pop(),
          ),
        ),
        Positioned(
          top: kToolbarHeight,
          right: 16.w,
          child: CommonDetailsActions(onShareTap: () {}, onLoveTap: () {}),
        ),
      ],
    );
  }

  Widget _buildRestaurantDetailsHeader(BuildContext context) {
    return CustomContainer(
      color: context.colors.background,
      topRightRadius: 32.r,
      topLeftRadius: 32.r,
      paddingVertical: 24.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: restaurant?.name ?? '',
            fontSize: 20.r,
            fontWeight: FontWeight.w600,
          ).horizontal(16.w),
          SizedBox(height: 4.w),

          CustomText(
            text: restaurant?.cuisineTypes.join(' · ') ?? '',
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
                  text: ' ${restaurant?.ratingAvg ?? 0} ',
                  style: TextStyle(color: context.colors.textPrimary),
                ),
                TextSpan(text: '(${restaurant?.ratingCount ?? 0} review) · '),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Icon(
                    Icons.access_time,
                    color: context.colors.iconSecondary,
                    size: 14.r,
                  ),
                ),
                TextSpan(text: ' ${restaurant?.avgPrepTimeMins ?? 0} mins  '),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Icon(
                    Icons.directions_bike,
                    color: context.colors.iconSecondary,
                    size: 14.r,
                  ),
                ),
                TextSpan(
                  text:
                      '  ৳${restaurant?.deliveryFee.toStringAsFixed(0) ?? 0} · ${restaurant?.distanceKm ?? 0.0}Km',
                ),
              ],
            ),
          ).horizontal(16.w),
          SizedBox(height: 12.w),

          RestaurantTagsRow(restaurant: restaurant),
        ],
      ),
    );
  }
}
