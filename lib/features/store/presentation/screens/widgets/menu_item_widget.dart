import 'package:cheering/core/common_widgets/quantity_button.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuItemWidget extends StatelessWidget {
  final int index;

  const MenuItemWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final hasQuantity = index == 0;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomNetworkImage(
            width: 66.r,
            height: 66.r,
            borderRadius: 12.r,
            imageUrl:
                'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38',
          ),
          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'Classic Cheeseburger',
                  fontWeight: FontWeight.w600,
                  maxLines: 1,
                  bottom: 2.h,
                ),
                CustomText(
                  text: '8 pcs crispy fried chicken, spiced',
                  color: context.colors.textTertiary,
                  fontSize: 12.sp,
                  maxLines: 1,
                ),
                SizedBox(height: 8.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: '৳450',
                      color: context.colors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14.sp,
                    ),

                    QuantityButton(
                      count: hasQuantity ? 3 : null,
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
