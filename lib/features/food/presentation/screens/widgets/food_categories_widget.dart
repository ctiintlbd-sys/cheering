import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FoodCategoriesWidget extends StatelessWidget {
  const FoodCategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      width: 74.w,
      height: 90.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomContainer(
            width: 68.r,
            height: 68.r,
            radiusAll: 48.r,
            alignment: Alignment.center,
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 0),
                blurRadius: 6,
                color: context.colors.black.withValues(alpha: 0.009),
              ),
            ],
            child: CustomNetworkImage(
              width: 50.r,
              height: 50.r,
              fit: BoxFit.contain,
              imageUrl: '',
              fallbackAsset: Assets.icons.menu.svg(),
            ),
          ),

          SizedBox(height: 4.h),

          SizedBox(
            width: 74.w,
            height: 16.h,
            child: CustomText(
              text: 'Chicken',
              fontWeight: FontWeight.w500,
              maxLines: 1,
              textOverflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
