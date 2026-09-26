import 'package:cheering/core/utils/app_date_formatter.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../domain/entities/order_tracking_entity.dart';
import '../../helpers/tracking_status.dart';

class TrackingTimeline extends StatelessWidget {
  const TrackingTimeline({super.key, required this.tracking});

  final OrderTrackingEntity tracking;

  @override
  Widget build(BuildContext context) {
    final current = TrackingStatus.progressIndex(tracking.status);

    return Column(
      children: [
        for (var i = 0; i < TrackingStatus.steps.length; i++)
          _TrackingTimelineItem(
            step: TrackingStatus.steps[i],
            isCompleted: i <= current,
            isLast: i == TrackingStatus.steps.length - 1,
            nextCompleted: i < current,
            time: TrackingStatus.timeForStep(
              TrackingStatus.steps[i].status,
              tracking.timeline,
            ),
          ),
      ],
    );
  }
}

class _TrackingTimelineItem extends StatelessWidget {
  const _TrackingTimelineItem({
    required this.step,
    required this.isCompleted,
    required this.isLast,
    required this.nextCompleted,
    required this.time,
  });

  final TrackingStep step;
  final bool isCompleted;
  final bool isLast;
  final bool nextCompleted;
  final DateTime? time;

  @override
  Widget build(BuildContext context) {
    final active = context.colors.bgSuccessSecondary;
    final inactive = context.colors.borderTertiary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 28.w,
          child: Column(
            children: [
              CustomContainer(
                width: 28.w,
                height: 28.w,
                radiusAll: 28,
                color: isCompleted ? active : Color(0xffCBD5E1),
                bordersColor: isCompleted ? active : inactive,
                alignment: Alignment.center,
                child: step.icon,
              ),
              if (!isLast)
                CustomContainer(
                  width: 2,
                  height: 28.w,
                  color: nextCompleted ? active : inactive,
                ),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 8.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: step.title,
                  fontWeight: FontWeight.w600,
                  color: isCompleted
                      ? context.colors.textPrimary
                      : context.colors.textTertiary,
                ),
                CustomText(
                  top: 2.w,
                  text: time != null
                      ? AppDateFormatter.formatTime(time!)
                      : '--',
                  fontSize: 12.r,
                  color: context.colors.textTertiary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
