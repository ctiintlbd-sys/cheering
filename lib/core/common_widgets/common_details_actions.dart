import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';

class CommonDetailsActions extends StatelessWidget {
  final VoidCallback onShareTap;
  final VoidCallback onLoveTap;

  const CommonDetailsActions({
    super.key,
    required this.onShareTap,
    required this.onLoveTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CommonActionIcon(icon: Assets.icons.foodShare.path, onTap: onShareTap),
        SizedBox(width: 8.w),
        CommonActionIcon(icon: Assets.icons.foodLove.path, onTap: onLoveTap),
      ],
    );
  }
}

class CommonActionIcon extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;
  final Color? color;
  final Color? iconColor;

  const CommonActionIcon({super.key, required this.icon, required this.onTap, this.color, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      onTap: onTap,
      paddingAll: 10.r,
      shape: BoxShape.circle,
      color: color ?? context.colors.white,
      alignment: Alignment.center,
      child: SvgPicture.asset(
        icon,
        height: 24.r,
        width: 24.r,
        colorFilter: ColorFilter.mode(
          iconColor ??
          context.colors.textPrimary,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
