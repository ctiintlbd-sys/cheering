import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/tracking/domain/entities/order_tracking_entity.dart';
import 'package:cheering/features/tracking/presentation/helpers/tracking_status.dart';
import 'package:cheering/features/tracking/presentation/screens/widgets/tracking_rider_card.dart';
import 'package:cheering/features/tracking/presentation/screens/widgets/tracking_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TrackingMapSheet extends StatelessWidget {
  const TrackingMapSheet({super.key, required this.tracking});

  final OrderTrackingEntity tracking;

  @override
  Widget build(BuildContext context) {
    final rider = tracking.rider;

    return CustomContainer(
      color: context.colors.background,
      topLeftRadius: 24.r,
      topRightRadius: 24.r,
      paddingHorizontal: 16.w,
      paddingTop: 12.w,
      paddingBottom: 24.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomContainer(
            width: 36.w,
            height: 4.w,
            radiusAll: 99.r,
            color: context.colors.borderSecondary,
          ),
          SizedBox(height: 20.w),
          CustomText(
            text: TrackingStatus.title(tracking),
            fontSize: 20.r,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.center,
          ),
          CustomText(
            top: 6.w,
            text: TrackingStatus.subtitle(tracking),
            color: context.colors.textTertiary,
            textAlign: TextAlign.center,
          ),
          if (rider != null) ...[
            SizedBox(height: 20.w),
            TrackingRiderCard(rider: rider),
          ],
          SizedBox(height: 20.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: 'My Order',
                fontSize: 16.r,
                fontWeight: FontWeight.w600,
              ),
              CustomText(
                text: 'Details',
                fontSize: 12.w,
                fontWeight: FontWeight.w500,
                color: context.colors.textTertiary,
              ),
            ],
          ),
          SizedBox(height: 16.w),
          TrackingTimeline(tracking: tracking),
        ],
      ),
    );
  }
}
