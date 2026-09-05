import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FoodFlexibleBackground extends StatelessWidget {
  const FoodFlexibleBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      height: 300.h,
      bottomRight: 20.h,
      bottomLeft: 20.h,
      paddingBottom: 24.h,
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
    );
  }
}
