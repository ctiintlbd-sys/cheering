import 'package:cheering/core/theme/app_theme_colors.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/custom_container.dart';
import 'package:cheering/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeliveryTitleWidget extends StatelessWidget {
  const DeliveryTitleWidget({super.key, required this.address});

  final String address;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildCircularIconButton(
          context: context,
          icon: Assets.icons.foodLocation.svg(),
          backgroundColor: context.colors.white.withValues(alpha: 0.15),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                textAlign: TextAlign.start,
                text: 'Delivery to',
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: context.colors.white.withValues(alpha: 0.8),
              ),
              CustomText(
                top: 2.h,
                textAlign: TextAlign.start,
                text: address,
                fontSize: 12.sp,
                maxLines: 1,
                textOverflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.w500,
                color: context.colors.white.withValues(alpha: 0.8),
              ),
            ],
          ),
        ),
        _buildCircularIconButton(
          context: context,
          icon: Assets.icons.foodLove.svg(),
          backgroundColor: context.colors.white.withValues(alpha: 0.15),
        ),
        SizedBox(width: 12.w),
        _buildCircularIconButton(
          context: context,
          icon: Assets.icons.cart.svg(),
          backgroundColor: context.colors.white,
        ),
      ],
    );
  }

  Widget _buildCircularIconButton({
    required BuildContext context,
    required Widget icon,
    required Color backgroundColor,
  }) {
    return CustomContainer(
      shape: BoxShape.circle,
      width: 44.r,
      height: 44.r,
      color: backgroundColor,
      boxShadow: [
        BoxShadow(
          offset: const Offset(-2, 2),
          blurRadius: 16,
          color: context.colors.black.withValues(alpha: 0.04),
        )
      ],
      alignment: Alignment.center,
      child: icon,
    );
  }
}
