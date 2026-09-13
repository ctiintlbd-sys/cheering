import 'dart:io';

import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileHeaderCard extends StatelessWidget {
  final String name;
  final String? subtitle;
  final String? imageUrl;
  final File? imageFile;
  final VoidCallback? onTap;
  final bool showTrailing;
  final Widget? trailing;

  const ProfileHeaderCard({
    super.key,
    this.name = 'Jenia Rahman',
    this.subtitle = 'Jenia Rahman',
    this.imageUrl = '',
    this.imageFile,
    this.onTap,
    this.showTrailing = true,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      onTap: onTap,
      paddingVertical: 8.h,
      paddingHorizontal: 12.w,
      radiusAll: 8.r,
      color: context.colors.bgSecondary,
      child: Row(
        children: [
          CustomNetworkImage(
            boxShape: BoxShape.circle,
            height: 64.r,
            width: 64.r,
            imageUrl: imageUrl,
            imageFile: imageFile,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  text: name,
                ),
                if (subtitle != null && subtitle!.isNotEmpty)
                  CustomText(
                    top: 4.h,
                    color: context.colors.textTertiary,
                    text: subtitle!,
                  ),
              ],
            ),
          ),
          if (trailing != null)
            trailing!
          else if (showTrailing)
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: context.colors.iconTertiary,
            ),
        ],
      ),
    );
  }
}
