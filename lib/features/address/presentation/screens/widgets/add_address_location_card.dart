import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_theme_colors.dart';

class AddAddressLocationCard extends StatelessWidget {
  const AddAddressLocationCard({
    super.key,
    required this.primaryLine,
    required this.secondaryLine,
    required this.onChangeTap,
  });

  final String primaryLine;
  final String secondaryLine;
  final VoidCallback onChangeTap;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      color: context.colors.bgSecondary,
      radiusAll: 16.r,
      paddingAll: 16.r,
      child: Row(
        children: [
          CustomContainer(
            width: 44.r,
            height: 44.r,
            color: context.colors.primary.withValues(alpha: 0.12),
            radiusAll: 12.r,
            child: Icon(
              Icons.location_on_rounded,
              color: context.colors.primary,
              size: 22.r,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: primaryLine.isEmpty ? 'Selected location' : primaryLine,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  maxLines: 2,
                ),
                if (secondaryLine.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  CustomText(
                    text: secondaryLine,
                    fontSize: 14.sp,
                    color: context.colors.textSecondary,
                    maxLines: 1,
                  ),
                ],
              ],
            ),
          ),
          CustomText(
            onTap: onChangeTap,
            text: 'Change',
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: context.colors.primary,
          ),
        ],
      ),
    );
  }
}
