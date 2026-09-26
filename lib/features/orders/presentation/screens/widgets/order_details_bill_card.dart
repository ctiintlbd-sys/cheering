import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/orders/domain/entities/order_detail_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderDetailsBillCard extends StatelessWidget {
  const OrderDetailsBillCard({super.key, required this.order});

  final OrderDetailEntity order;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Bill details',
          fontSize: 16.r,
          fontWeight: FontWeight.w600,
        ),
        SizedBox(height: 12.w),
        CustomContainer(
          color: context.colors.background,
          radiusAll: 16,
          boxShadow: [
            BoxShadow(
              color: context.colors.black.withValues(alpha: 0.03),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
          child: Column(
            children: [
              _row(context, 'Item total', '৳${order.itemTotal.toStringAsFixed(0)}'),
              if (order.deliveryFee > 0)
                _row(context, 'Delivery fee', '৳${order.deliveryFee.toStringAsFixed(0)}'),
              if (order.packagingFee > 0)
                _row(context, 'Packaging fee', '৳${order.packagingFee.toStringAsFixed(0)}'),
              if (order.taxAmount > 0)
                _row(context, 'Tax', '৳${order.taxAmount.toStringAsFixed(0)}'),
              if (order.platformFee > 0)
                _row(context, 'Platform fee', '৳${order.platformFee.toStringAsFixed(0)}'),
              if (order.tip > 0)
                _row(context, 'Rider tip', '৳${order.tip.toStringAsFixed(0)}'),
              if (order.discount > 0)
                _row(
                  context,
                  'Discount',
                  '-৳${order.discount.toStringAsFixed(0)}',
                  valueColor: context.colors.bgSuccessSecondary,
                ),
              _row(
                context,
                '${order.itemCount} pcs',
                '৳${order.grandTotal.toStringAsFixed(0)}',
                valueColor: context.colors.primary,
                fontWeight: FontWeight.w600,
                showDivider: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _row(
    BuildContext context,
    String title,
    String amount, {
    Color? valueColor,
    FontWeight? fontWeight,
    bool showDivider = true,
  }) {
    return CustomContainer(
      paddingAll: 16.w,
      border: showDivider
          ? Border(bottom: BorderSide(color: context.colors.borderTertiary))
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(text: title, fontWeight: fontWeight ?? FontWeight.w400),
          CustomText(
            text: amount,
            fontWeight: fontWeight ?? FontWeight.w400,
            color: valueColor ?? context.colors.textPrimary,
          ),
        ],
      ),
    );
  }
}
