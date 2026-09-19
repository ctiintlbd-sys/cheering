import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/food/domain/entities/category_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class FoodCategoriesWidget extends StatelessWidget {
  const FoodCategoriesWidget({super.key, required this.category});

  final CategoryEntity category;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(RoutePaths.categoryDetails);
      },
      child: CustomContainer(
        width: 74.w,
        height: 90.h,
        color: Colors.transparent,
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
                  color: Colors.transparent,
                ),
              ],
              child: CustomNetworkImage(
                width: 50.r,
                height: 50.r,
                fit: BoxFit.contain,
                imageUrl: category.imageUrl,
                fallbackAsset: Assets.icons.menu.svg(),
              ),
            ),

            SizedBox(height: 4.h),

            SizedBox(
              width: 74.w,
              height: 16.h,
              child: CustomText(
                text: category.name,
                fontWeight: FontWeight.w500,
                maxLines: 1,
                textOverflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SeeAllCategoriesWidget extends StatelessWidget {
  final VoidCallback? onTap;

  const SeeAllCategoriesWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomContainer(
        verticalMargin: 4.h,
        width: 32.r,
        height: 32.r,
        shape: BoxShape.circle,
        alignment: Alignment.center,
        color: context.colors.primary.withValues(alpha: 0.08),
        child: Icon(
          Icons.arrow_forward_rounded,
          size: 18.r,
          color: context.colors.primary,
        ),
      ),
    );
  }
}
