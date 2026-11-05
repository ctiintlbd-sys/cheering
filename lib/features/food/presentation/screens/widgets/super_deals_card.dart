import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/food/domain/entities/restaurant_entity.dart';
import 'package:cheering/features/food/presentation/screens/widgets/animated_promotion_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:go_router/go_router.dart';
import 'package:cheering/core/router/route_paths.dart';

class SuperDealsCard extends StatelessWidget {
  final RestaurantEntity restaurant;

  const SuperDealsCard({super.key, required this.restaurant});

  String get _imageUrl {
    bool valid(String? u) => u != null && u.startsWith('http');
    if (valid(restaurant.coverImageUrl)) return restaurant.coverImageUrl!;
    if (valid(restaurant.logoUrl)) return restaurant.logoUrl!;
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final r = restaurant;
    final cuisines = r.cuisineTypes.where((e) => e.isNotEmpty).join(' • ');
    final isFreeDelivery = r.deliveryFee <= 0;
    final hasPromos = r.promotions != null && r.promotions!.isNotEmpty;

    return CustomContainer(
      onTap: () => context.push(
        RoutePaths.storeDetails(restaurant.id),
        extra: restaurant,
      ),
      verticalMargin: 4.w,
      width: 248.w,
      height: 220.w,
      radiusAll: 12.r,
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          CustomNetworkImage(
            width: 248.w,
            borderRadius: 12.r, imageUrl: _imageUrl),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  context.colors.black.withValues(alpha: 0.85),
                  context.colors.black.withValues(alpha: 0.0),
                ],
                stops: const [0.0, 0.7],
              ),
            ),
          ),
          Positioned(
            top: 12.w,
            left: 12.w,
            child: CustomContainer(
              alignment: Alignment.center,
              color: context.colors.primaryLight.withValues(alpha: 0.8),
              radiusAll: 16.r,
              paddingVertical: 4.w,
              paddingHorizontal: 8.w,
              child: CustomText(
                text: r.isOpen ? 'Open' : 'Closed',
                color: context.colors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 12.r,
              ),
            ),
          ),
          if (hasPromos)
            Positioned(
              top: 12.w,
              right: 12.w,
              child: AnimatedPromotionBadge(
                promotions: r.promotions!,
                paddingHorizontal: 8.w,
                paddingVertical: 4.w,
                borderRadius: 16.r,
                fontSize: 11.r,
                iconSize: 11.r,
              ),
            ),
          Positioned(
            bottom: 12.w,
            left: 12.w,
            right: 12.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  text: r.name,
                  color: context.colors.white,
                  fontWeight: FontWeight.w600,
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
                if (cuisines.isNotEmpty) ...[
                  SizedBox(height: 4.w),
                  CustomText(
                    text: cuisines,
                    color: context.colors.white.withValues(alpha: 0.66),
                    fontSize: 12.r,
                    maxLines: 1,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ],
                SizedBox(height: 4.w),
                RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    style: TextStyle(
                      color: context.colors.white.withValues(alpha: 0.8),
                      fontSize: 12.r,
                    ),
                    children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          Icons.star,
                          color: context.colors.ratingColor,
                          size: 12.r,
                        ),
                      ),
                      TextSpan(text: ' ${r.ratingAvg.toStringAsFixed(1)} '),
                      const TextSpan(text: '• '),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          Icons.directions_bike,
                          color:
                              isFreeDelivery
                                  ? context.colors.success
                                  : context.colors.white.withValues(alpha: 0.8),
                          size: 12.r,
                        ),
                      ),
                      TextSpan(
                        text:
                            isFreeDelivery
                                ? ' Free (${r.distanceKm.toStringAsFixed(1)}Km) '
                                : ' ৳${r.deliveryFee.toStringAsFixed(0)} (${r.distanceKm.toStringAsFixed(1)}Km) ',
                        style:
                            isFreeDelivery
                                ? TextStyle(
                                  color: context.colors.success,
                                  fontWeight: FontWeight.w600,
                                )
                                : null,
                      ),
                      const TextSpan(text: '• '),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          Icons.access_time,
                          color: context.colors.white.withValues(alpha: 0.8),
                          size: 12.r,
                        ),
                      ),
                      TextSpan(text: ' ${r.avgPrepTimeMins} mins'),
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
