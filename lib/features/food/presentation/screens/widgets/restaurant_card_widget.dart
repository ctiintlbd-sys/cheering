import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/food/domain/entities/restaurant_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class RestaurantCardWidget extends StatelessWidget {
  const RestaurantCardWidget({
    super.key,
    required this.restaurant,
    this.isFavorite,
    this.onFavoriteTap,
  });

  final RestaurantEntity restaurant;
  final bool? isFavorite;
  final VoidCallback? onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        context.push(RoutePaths.storeDetails(restaurant.id), extra: restaurant);
      },
      child: SizedBox(
        width:  174.w,
        height:  196.w,
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
                if (!restaurant.isOpen)
                  Positioned.fill(
                    child: CustomContainer(
                      alignment: Alignment.center,
                      radiusAll: 12.r,
                      color: context.colors.black.withValues(alpha: 0.7),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomText(
                              bottom: 8.w,
                              textAlign: TextAlign.center,
                              text: 'Closed for\nnow',
                              color: context.colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            CustomButton(
                              backgroundColor: context.colors.white,
                              foregroundColor: context.colors.primary,
                              fontWeight: FontWeight.w600,
                              radius: 6.r,
                              height: 28.w,
                              fontSize: 12.w,
                              onPressed: () {
                                context.push(
                                  RoutePaths.storeDetails(restaurant.id),
                                  extra: restaurant,
                                );
                              },
                              label: 'Order for later',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8.w,
                    right: 8.w,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: onFavoriteTap,
                      child: CustomContainer(
                        alignment: Alignment.center,
                        height: 28.w,
                        width: 28.w,
                        shape: BoxShape.circle,
                        color: context.colors.black.withValues(alpha: 0.1),
                        child: Icon(
                          (isFavorite ?? restaurant.isFavorite) == true
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: (isFavorite ?? restaurant.isFavorite) == true
                              ? context.colors.primary
                              : context.colors.white,
                          size: 16.r,
                        ),
                      ),
                    ),
                  ),
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
