import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../domain/entities/business_hours_entity.dart';

import 'package:cheering/core/utils/app_date_formatter.dart';

class DayScheduleItem extends StatelessWidget {
  final String dayLabel;
  final DayHoursEntity dayHours;
  final VoidCallback onTap;
  final ValueChanged<bool> onToggle;

  const DayScheduleItem({
    super.key,
    required this.dayLabel,
    required this.dayHours,
    required this.onTap,
    required this.onToggle,
  });

  String get _timeRange {
    if (!dayHours.isOpen) return 'Closed';
    final openStr = AppDateFormatter.format24HourTime(dayHours.opensAt);
    final closeStr = AppDateFormatter.format24HourTime(dayHours.closesAt);
    return '$openStr – $closeStr';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 56.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            alignment: Alignment.center,
            color: Colors.transparent, // Ensures the whole row is clickable
            child: Row(
              children: [
                // Day Label
                SizedBox(
                  width: 50.w,
                  child: CustomText(
                    text: dayLabel,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: context.colors.textPrimary,
                  ),
                ),

                // Time range
                Expanded(
                  child: CustomText(
                    text: _timeRange,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: dayHours.isOpen
                        ? context.colors.textSecondary
                        : context.colors.textPlaceholder,
                  ),
                ),

                // Toggle Switch
                CupertinoSwitch(
                  value: dayHours.isOpen,
                  activeTrackColor: context.colors.success,
                  onChanged: onToggle,
                ),
              ],
            ),
          ),
        ),
        Divider(
          color: context.colors.outline.withValues(alpha: 0.5),
          height: 1,
          thickness: 1,
        ),
      ],
    );
  }
}
