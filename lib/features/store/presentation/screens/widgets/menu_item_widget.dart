import 'package:cheering/core/common_widgets/quantity_button.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/food/domain/entities/menu_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuItemWidget extends StatelessWidget {
  final MenuItemEntity? menuItem;

  const MenuItemWidget({super.key,  this.menuItem,});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomNetworkImage(
            width: 66.r,
            height: 66.r,
            borderRadius: 12.r,
            imageUrl: menuItem?.imageUrl ),
          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: menuItem?.name ?? '',
                  fontWeight: FontWeight.w600,
                  maxLines: 1,
                  bottom: 2.w,
                ),
                if (menuItem?.description != null && menuItem!.description!.isNotEmpty)
                  CustomText(
                    text: menuItem!.description!,
                    color: context.colors.textTertiary,
                    fontSize: 12.r,
                    maxLines: 1,
                  ),
                SizedBox(height: 8.w),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: '৳${menuItem?.basePrice.toStringAsFixed(0) ?? '0'}',
                      color: context.colors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14.r,
                    ),

                    QuantityButton(
                      count: null,
                      onIncrement: () {},
                      onDecrement: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
