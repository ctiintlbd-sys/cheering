import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ApplyToWeekdaysCard extends StatelessWidget {
  final bool isApplied;
  final ValueChanged<bool> onChanged;

  const ApplyToWeekdaysCard({
    super.key,
    required this.isApplied,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      horizontalMargin: 16.w,
      onTap: () {
        onChanged(!isApplied);
      },
      paddingAll: 12.r,
      border: Border.symmetric(
        horizontal: BorderSide(color: context.colors.borderTertiary),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Apply to Mon – Fri',
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                bottom: 4.h,
              ),
              CustomText(
                text: 'Copy these hours to weekdays',
                color: context.colors.textSecondary,
              ),
            ],
          ),
          CustomContainer(
            alignment: Alignment.center,
            width: 24.r,
            height: 24.r,
            radiusAll: 8.r,
            bordersColor: context.colors.textPrimary,
            color: isApplied ? context.colors.iconPrimary : Colors.transparent,
            child: isApplied
                ? Icon(
                    Icons.check_rounded,
                    size: 12.sp,
                    color: context.colors.white,
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
