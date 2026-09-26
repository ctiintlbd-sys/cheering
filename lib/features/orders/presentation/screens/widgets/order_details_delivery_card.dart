import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/cart/data/models/payment_method_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderDetailsDeliveryCard extends StatelessWidget {
  const OrderDetailsDeliveryCard({
    super.key,
    required this.address,
    required this.paymentMethod,
  });

  final String address;
  final String paymentMethod;

  @override
  Widget build(BuildContext context) {
    final payment = PaymentMethodItem.byValue(paymentMethod);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Delivered to',
          fontSize: 16.r,
          fontWeight: FontWeight.w600,
        ),
        SizedBox(height: 12.w),
        CustomContainer(
          color: context.colors.background,
          radiusAll: 16,
          paddingHorizontal: 14.w,
          paddingVertical: 16.w,
          boxShadow: [
            BoxShadow(
              color: context.colors.black.withValues(alpha: 0.03),
              offset: const Offset(0, 1),
              blurRadius: 2,
            ),
          ],
          child: Column(
            children: [
              Row(
                children: [
                  Assets.icons.orderLocataion.svg(),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: CustomText(
                      text: address,
                      fontSize: 14.r,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
              Divider(height: 28.w, color: context.colors.borderTertiary),
              Row(
                children: [
                  payment?.icon ??
                      Icon(Icons.money, size: 20.r, color: Colors.green),
                  SizedBox(width: 12.w),
                  CustomText(
                    text: payment?.title ?? paymentMethod,
                    fontSize: 14.r,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
