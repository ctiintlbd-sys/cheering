import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/food/domain/entities/restaurant_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class HRestaurantCardWidget extends StatelessWidget {
  const HRestaurantCardWidget({super.key, this.restaurant});

  final RestaurantEntity? restaurant;

  @override
  Widget build(BuildContext context) {
    final isFreeDelivery = (restaurant?.deliveryFee ?? 1) <= 0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (restaurant != null) context.push(RoutePaths.storeDetails(restaurant!.id), extra: restaurant);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                CustomNetworkImage(
                  width: 102.w,
                  height: 84.w,
                  borderRadius: 12.r,
                  imageUrl: restaurant?.logoUrl ?? restaurant?.coverImageUrl,
                ),
                if(restaurant?.isOpen == false)
                  Positioned.fill(child: CustomContainer(
                    alignment: Alignment.center,
                    radiusAll: 12.r,
                    color: context.colors.black.withValues(alpha: 0.7),
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 8.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomText(
                              bottom: 6.w,
                              textAlign: TextAlign.center,
                              fontSize: 10.w,
                              text: 'Closed for\nnow',color: context.colors.white,fontWeight: FontWeight.w600),
                          CustomButton(
                              backgroundColor: context.colors.white,
                              foregroundColor: context.colors.primary,
                              fontWeight: FontWeight.w600,
                              radius: 6.r,
                              height: 24.w,
                              fontSize: 10.w,
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              onPressed: (){
                                if (restaurant != null) context.push(RoutePaths.storeDetails(restaurant!.id), extra: restaurant);
                              },label: 'Order for later')
                        ],
                      ),
                    ),
                  )),
              ],
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
                          text: restaurant?.name ?? '',
                          fontWeight: FontWeight.w600,
                          maxLines: 1,
                        ),
                      ),
                      CustomContainer(
                        paddingAll: 6.r,
                        shape: BoxShape.circle,
                        color: context.colors.bgSecondary,
                        child: Icon(
                          restaurant?.isFavorite == true
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: context.colors.primary,
                          size: 16.r,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.w),

                  // Subtitle
                  if (restaurant != null &&
                      restaurant!.cuisineTypes.isNotEmpty) ...[
                    CustomText(
                      text: restaurant!.cuisineTypes.take(2).join(' · '),
                      color: context.colors.textSecondary,
                      fontSize: 12.r,
                      maxLines: 1,
                    ),
                    SizedBox(height: 6.w),
                  ],

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
                          text:
                              ' ${restaurant?.ratingAvg.toStringAsFixed(1) ?? 0.0}  ·  ',
                        ),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Icon(
                            Icons.directions_bike,
                            color:
                                isFreeDelivery
                                    ? context.colors.success
                                    : context.colors.iconSecondary,
                            size: 14.r,
                          ),
                        ),
                        TextSpan(
                          text:
                              isFreeDelivery
                                  ? ' Free (${restaurant?.distanceKm.toStringAsFixed(1) ?? 0.0}Km)  ·  '
                                  : ' ৳${restaurant?.deliveryFee.toStringAsFixed(0) ?? 0}(${restaurant?.distanceKm.toStringAsFixed(1) ?? 0.0}Km)  ·  ',
                          style:
                              isFreeDelivery
                                  ? TextStyle(
                                    color: context.colors.success,
                                    fontWeight: FontWeight.w600,
                                  )
                                  : null,
                        ),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Icon(
                            Icons.access_time,
                            color: context.colors.iconSecondary,
                            size: 14.r,
                          ),
                        ),
                        TextSpan(
                          text: ' ${restaurant?.avgPrepTimeMins ?? 0.0} mins',
                        ),
                      ],
                    ),
                  ),

                  // Discount Tags (Horizontally Scrollable)
                  if (restaurant?.promotions != null &&
                      restaurant!.promotions!.isNotEmpty) ...[
                    SizedBox(height: 10.w),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (
                            var i = 0;
                            i < restaurant!.promotions!.length;
                            i++
                          ) ...[
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.w,
                              ),
                              decoration: BoxDecoration(
                                color: context.colors.primary.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(32.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.local_offer_outlined,
                                    color: context.colors.primary,
                                    size: 12.r,
                                  ),
                                  CustomText(
                                    left: 4.w,
                                    text:
                                        restaurant!
                                            .promotions![i]
                                            .displayDiscount,
                                    color: context.colors.primary,
                                    fontSize: 10.r,
                                    fontWeight: FontWeight.w600,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                            if (i < restaurant!.promotions!.length - 1)
                              SizedBox(width: 6.w),
                          ],
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
