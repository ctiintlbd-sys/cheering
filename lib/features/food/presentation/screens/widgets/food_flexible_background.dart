import 'package:cheering/core/theme/app_theme_colors.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/custom_container.dart';
import 'package:cheering/core/widgets/custom_network_image.dart';
import 'package:cheering/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FoodFlexibleBackground extends StatelessWidget {
  const FoodFlexibleBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CustomContainer(
          height: 276.h,
          bottomRight: 20.h,
          bottomLeft: 20.h,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20.h),
              bottomLeft: Radius.circular(20.h),
            ),
            child: CustomNetworkImage(
              imageUrl: '',
              fallbackAsset: Assets.images.foodBanner.image(
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned(
          left: 16.w,
          right: 16.w,
          bottom: 0.h,
          child: CustomTextField(
            onTap: () {},
            readOnly: true,
            prefixIcon: Assets.icons.search.svg(),
            suffixIcon: Assets.icons.filtter.svg(),
            borderRadius: 99.r,
            fillColor: context.colors.background,
            borderColor: context.colors.borderSecondary,
            hintText: 'Search food...',
          ),
        ),
      ],
    );
  }
}
