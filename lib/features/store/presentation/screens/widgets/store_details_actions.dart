import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';

class StoreDetailsActions extends StatelessWidget {
  final VoidCallback onShareTap;
  final VoidCallback onLoveTap;

  const StoreDetailsActions({
    super.key,
    required this.onShareTap,
    required this.onLoveTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        StoreActionIcon(icon: Assets.icons.foodShare.path, onTap: onShareTap),
        SizedBox(width: 8.w),
        StoreActionIcon(icon: Assets.icons.foodLove.path, onTap: onLoveTap),
        SizedBox(width: 16.w),
      ],
    );
  }
}

class StoreActionIcon extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;

  const StoreActionIcon({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      onTap: onTap,
      paddingAll: 10.r,
      shape: BoxShape.circle,
      color: context.colors.white,
      alignment: Alignment.center,
      child: SvgPicture.asset(
        icon,
        height: 24.r,
        width: 24.r,
        colorFilter: ColorFilter.mode(
          context.colors.textPrimary,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
