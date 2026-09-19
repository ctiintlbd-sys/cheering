import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/food/domain/entities/restaurant_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class StoreCardWidget extends StatelessWidget {
  const StoreCardWidget({super.key, required this.restaurant});

  final RestaurantEntity restaurant;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        context.push(RoutePaths.storeDetails);
      },
      child: SizedBox(
        width: 174.w,
        height: 194.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomNetworkImage(
              height: 124.h,
              width: double.maxFinite,
              borderRadius: 12.r,
              imageUrl: restaurant.logoUrl,
            ),
            CustomText(
              top: 10.h,
              text: restaurant.name,
              fontWeight: FontWeight.w500,
              maxLines: 1,
              textOverflow: TextOverflow.ellipsis,
            ),
            RichText(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: TextStyle(
                  height: 1.55,
                  fontSize: 12.sp,
                  color: context.colors.textTertiary,
                ),
                children: [
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Icon(
                      Icons.directions_bike,
                      color: context.colors.iconSecondary,
                      size: 12.r,
                    ),
                  ),
                  TextSpan(text: ' ৳${restaurant.deliveryFee.toStringAsFixed(0)} '),
                  TextSpan(text: '•'),
                  TextSpan(text: ' ${restaurant.distanceKm}Km\n'),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Icon(
                      Icons.star,
                      color: context.colors.ratingColor,
                      size: 12.r,
                    ),
                  ),
                  TextSpan(text: ' ${restaurant.ratingAvg} (${restaurant.ratingCount}) '),
                  TextSpan(text: '•'),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Icon(
                      Icons.access_time,
                      color: context.colors.iconSecondary,
                      size: 12.r,
                    ),
                  ),
                  TextSpan(text: ' ${restaurant.avgPrepTimeMins} mins'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
