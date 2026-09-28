import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/food/domain/entities/menu_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SearchDishTile extends StatelessWidget {
  const SearchDishTile({super.key, required this.item});

  final MenuItemEntity item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.push(RoutePaths.itemDetails, extra: item),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomNetworkImage(
              width: 66.r,
              height: 66.r,
              borderRadius: 12.r,
              imageUrl: item.imageUrl,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: item.name,
                    fontWeight: FontWeight.w600,
                    maxLines: 1,
                  ),
                  if (item.restaurantName != null &&
                      item.restaurantName!.isNotEmpty)
                    CustomText(
                      top: 2.w,
                      text: item.restaurantName!,
                      color: context.colors.textSecondary,
                      fontSize: 12.r,
                      maxLines: 1,
                    ),
                  CustomText(
                    top: 8.w,
                    text: '৳${item.basePrice.toStringAsFixed(0)}',
                    color: context.colors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 14.r,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
