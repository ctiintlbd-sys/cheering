import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FoodFlexibleBackground extends StatelessWidget {
  const FoodFlexibleBackground({
    super.key,
    required this.imageUrl,
    this.fallbackAsset,
  });

  final String imageUrl;
  final Widget? fallbackAsset;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      height: 300.w,
      bottomRight: 20.w,
      bottomLeft: 20.w,
      paddingBottom: 24.w,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20.w),
          bottomLeft: Radius.circular(20.w),
        ),
        child: CustomNetworkImage(
          imageUrl: imageUrl,
          fallbackAsset:
              fallbackAsset ??
              Assets.images.foodBanner.image(
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
        ),
      ),
    );
  }
}
