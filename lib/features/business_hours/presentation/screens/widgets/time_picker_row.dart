import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/core/helpers/date_picker_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:cheering/core/utils/app_date_formatter.dart';

class TimePickerRow extends StatelessWidget {
  final String opensAt;
  final String closesAt;
  final Function(String) onOpensAtChanged;
  final Function(String) onClosesAtChanged;

  const TimePickerRow({
    super.key,
    required this.opensAt,
    required this.closesAt,
    required this.onOpensAtChanged,
    required this.onClosesAtChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: _buildTimeBox(
              context: context,
              label: 'OPENS AT',
              timeValue: AppDateFormatter.format24HourTime(opensAt),
              onTap: () => _pickTime(context, true),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildTimeBox(
              context: context,
              label: 'CLOSES AT',
              timeValue: AppDateFormatter.format24HourTime(closesAt),
              onTap: () => _pickTime(context, false),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeBox({
    required BuildContext context,
    required String label,
    required String timeValue,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: CustomContainer(
        paddingAll: 16.r,
        radiusAll: 16.r,
        color: context.colors.bgSecondary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: label,
              fontWeight: FontWeight.w500,
              color: context.colors.textSecondary,
              bottom: 4.h,
            ),
            CustomText(
              text: timeValue,
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickTime(BuildContext context, bool isOpeningTime) async {
    final initialStr = isOpeningTime ? opensAt : closesAt;

    TimeOfDay initialTime = const TimeOfDay(hour: 10, minute: 0);
    if (initialStr.isNotEmpty) {
      try {
        final parts = initialStr.split(':');
        initialTime = TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      } catch (_) {}
    }

    final picked = await context.pickTime(initialTime: initialTime);

    if (picked != null) {
      final timeStr =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      if (isOpeningTime) {
        onOpensAtChanged(timeStr);
      } else {
        onClosesAtChanged(timeStr);
      }
    }
  }
}
