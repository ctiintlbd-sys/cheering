import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/food/domain/entities/restaurant_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class RestaurantCardWidget extends StatelessWidget {
  const RestaurantCardWidget({super.key, required this.restaurant});

  final RestaurantEntity restaurant;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: restaurant.isOpen ? () {
        context.push(RoutePaths.storeDetails(restaurant.id), extra: restaurant);
      } : null,
      child: SizedBox(
        width: 174.w,
        height: 194.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CustomNetworkImage(
                  height: 124.w,
                  width: double.maxFinite,
                  borderRadius: 12.r,
                  imageUrl: restaurant.logoUrl,
                ),
                if(!restaurant.isOpen)
                Positioned.fill(child: CustomContainer(
                  alignment: Alignment.center,
                  radiusAll: 12.r,
                  color: context.colors.black.withValues(alpha: 0.7),
                  child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomText(
                          bottom: 8.w,
                          textAlign: TextAlign.center,
                            text: 'Opens at\nSun, 11:00 AM',color: context.colors.white,fontWeight: FontWeight.w600),
                        CustomButton(
                          backgroundColor: context.colors.white,
                          foregroundColor: context.colors.primary,
                          fontWeight: FontWeight.w600,
                          radius: 6.r,
                          height: 28.w,
                          fontSize: 12.w,
                          onPressed: (){},label: 'Order for later')
                      ],
                    ),
                  ),
                )),
              ],
            ),
            CustomText(
              top: 10.w,
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
                  fontSize: 12.r,
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
                  TextSpan(
                    text: ' ৳${restaurant.deliveryFee.toStringAsFixed(0)} ',
                  ),
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
                  TextSpan(
                    text:
                        ' ${restaurant.ratingAvg} (${restaurant.ratingCount}) ',
                  ),
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
