import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreatePostBar extends StatelessWidget {
  final VoidCallback? onTap;

  const CreatePostBar({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      onTap: onTap,
      radiusAll: 16.r,
      color: context.colors.white,
      bordersColor: context.colors.outline,
      paddingAll: 12.r,
      child: Row(
        children: [
          CustomNetworkImage(
            borderRadius: 20.r,
            imageUrl: '',
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: CustomText(
              text: "Share something with the community...",
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: context.colors.textSecondary,
              textAlign: TextAlign.start,
            ),
          ),
          SizedBox(width: 8.w),
          Icon(
            Icons.photo_library_outlined,
            size: 22.r,
            color: context.colors.primary,
          ),
        ],
      ),
    );
  }
}
