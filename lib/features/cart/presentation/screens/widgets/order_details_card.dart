import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderDetailsCard extends StatelessWidget {
  final String restaurantName;
  final String deliveryAddress;
  final int itemCount;
  final String mainItemName;
  final String paymentMethod;

  const OrderDetailsCard({
    super.key,
    required this.restaurantName,
    required this.deliveryAddress,
    required this.itemCount,
    required this.mainItemName,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      color: context.colors.background,
      radiusAll: 16,
      bordersColor: context.colors.borderTertiary,
      paddingHorizontal: 14.w,
      paddingVertical: 12.w,
      boxShadow: [
        BoxShadow(
          color: context.colors.black.withValues(alpha: 0.02),
          offset: const Offset(0, 1),
          blurRadius: 2,
        )
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Assets.icons.orderLocataion.svg(),
              SizedBox(width: 12.w),
              Expanded(
                child: CustomText(
                  text: restaurantName,
                  fontSize: 14.r,
                  fontWeight: FontWeight.w500,
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 9.w, top: 4.h, bottom: 4.h),
            child: Container(
              height: 20.h,
              width: 1,
              color: context.colors.outline,
            ),
          ),
          Row(
            children: [
              Assets.icons.orderLocataion.svg(),
              SizedBox(width: 12.w),
              Expanded(
                child: CustomText(
                  text: deliveryAddress,
                  fontSize: 14.r,
                  fontWeight: FontWeight.w400,
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Divider(height: 32.h, color: context.colors.outline),
          Row(
            children: [
              CustomText(
                text: '${itemCount}x',
                fontSize: 14.r,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: CustomText(
                  text: mainItemName,
                  fontSize: 14.r,
                  fontWeight: FontWeight.w500,
                  color: context.colors.textSecondary,
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Divider(height: 32.h, color: context.colors.outline),
          Row(
            children: [
              Icon(Icons.money, size: 20.r, color: Colors.green),
              SizedBox(width: 12.w),
              CustomText(
                text: paymentMethod,
                fontSize: 14.r,
                fontWeight: FontWeight.w500,
                color: context.colors.textSecondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
