import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StoreProfileTile extends StatelessWidget {
  final Widget icon;
  final String label;
  final String? value;
  final String? subtitle;
  final bool hasChevron;
  final VoidCallback? onTap;

  const StoreProfileTile({
    super.key,
    required this.icon,
    required this.label,
    this.value,
    this.subtitle,
    this.hasChevron = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SizedBox(
          height: 62.h,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              SizedBox(width: 12.w),

              // Label & Subtitle (Left/Center)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(text: label, fontWeight: FontWeight.w600),
                    if (subtitle != null) ...[
                      SizedBox(height: 2.h),
                      CustomText(
                        text: subtitle!,
                        fontSize: 12.sp,
                        maxLines: 1,
                        textOverflow: TextOverflow.ellipsis,
                        color: context.colors.textSecondary,
                      ),
                    ],
                  ],
                ),
              ),

              // Value (Right side)
              if (value != null)
                CustomText(
                  text: value!,
                  fontWeight: FontWeight.w500,
                  color: context.colors.textSecondary,
                ),

              // Trailing Chevron
              if (hasChevron) ...[
                SizedBox(width: 6.w),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20.sp,
                  color: context.colors.iconTertiary,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
