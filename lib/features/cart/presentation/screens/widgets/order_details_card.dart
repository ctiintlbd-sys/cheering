import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/cart/data/models/payment_method_item.dart';
import 'package:cheering/features/cart/domain/entities/cart_item_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderDetailsCard extends StatelessWidget {
  final String restaurantName;
  final String deliveryAddress;
  final List<CartItemEntity> items;
  final String paymentMethod;

  const OrderDetailsCard({
    super.key,
    required this.restaurantName,
    required this.deliveryAddress,
    required this.items,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    final payment = PaymentMethodItem.byValue(paymentMethod);

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
        ),
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
          for (var i = 0; i < items.length; i++) ...[
            Row(
              children: [
                CustomText(
                  text: '${items[i].quantity}x',
                  fontSize: 14.r,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: CustomText(
                    text: items[i].name,
                    fontSize: 14.r,
                    fontWeight: FontWeight.w500,
                    color: context.colors.textSecondary,
                    maxLines: 1,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (i != items.length - 1) SizedBox(height: 8.h),
          ],
          Divider(height: 32.h, color: context.colors.outline),
          Row(
            children: [
              payment?.icon ??
                  Icon(Icons.money, size: 20.r, color: Colors.green),
              SizedBox(width: 12.w),
              CustomText(
                text: payment?.title ?? paymentMethod,
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
