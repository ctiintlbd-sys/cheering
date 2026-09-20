import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SectionHeaderWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const SectionHeaderWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              fontSize: 16.r,
              fontWeight: FontWeight.w600,
              text: title,
            ),
            if (subtitle != null)
              CustomText(
                top: 4.w,
                fontSize: 12.r,
                color: context.colors.textSecondary,
                text: subtitle!,
              ),
          ],
        ),
        if (onTap != null)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Row(
              children: [
                CustomText(
                  color: context.colors.textSecondary,
                  fontWeight: FontWeight.w600,
                  text: 'See All',
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16.r,
                  color: context.colors.iconSecondary,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
