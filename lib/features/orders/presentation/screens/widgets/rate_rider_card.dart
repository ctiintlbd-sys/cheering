import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/orders/presentation/screens/widgets/rating_stars_row.dart';
import 'package:cheering/features/tracking/domain/entities/order_tracking_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RateRiderCard extends StatelessWidget {
  const RateRiderCard({
    super.key,
    required this.rider,
    required this.rating,
    required this.onChanged,
    this.deliveryMinutes = 0,
    this.riderRating,
  });

  final TrackingRiderEntity rider;
  final int rating;
  final ValueChanged<int> onChanged;
  final int deliveryMinutes;
  final double? riderRating;

  @override
  Widget build(BuildContext context) {
    final avgRating = riderRating ?? rider.ratingAvg ?? 0.0;

    return CustomContainer(
      color: context.colors.background,
      radiusAll: 16.r,
      paddingAll: 16.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RatingStarsRow(
            title: 'Rate your rider',
            rating: rating,
            onChanged: onChanged,
          ),
          SizedBox(height: 14.w),
          CustomContainer(
            radiusAll: 12.r,
            color: context.colors.bgSecondary,
            paddingAll: 10.w,
            child: Row(
              children: [
                CustomNetworkImage(
                  width: 44.r,
                  height: 44.r,
                  boxShape: BoxShape.circle,
                  imageUrl: rider.photoUrl,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: rider.name,
                        fontSize: 15.r,
                        fontWeight: FontWeight.w600,
                        maxLines: 1,
                      ),
                      SizedBox(height: 4.w),
                      RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 12.r,
                            color: context.colors.textTertiary,
                          ),
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Assets.icons.star.svg(
                                height: 12.r,
                                width: 12.r,
                                color: context.colors.ratingColor,
                              ),
                            ),
                            TextSpan(
                              text: ' ${avgRating.toStringAsFixed(1)}',
                              style: TextStyle(
                                color: context.colors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const TextSpan(text: ' • '),
                            TextSpan(
                              text: 'Delivered in $deliveryMinutes mins',
                            ),
                          ],
                        ),
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
