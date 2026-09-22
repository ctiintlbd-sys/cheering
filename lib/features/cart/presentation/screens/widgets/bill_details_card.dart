import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BillDetailsCard extends StatelessWidget {
  final double itemTotal;
  final int itemCount;
  final double minOrderAmount;

  const BillDetailsCard({
    super.key,
    required this.itemTotal,
    required this.itemCount,
    required this.minOrderAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomText(
          left: 16.w,
          text: 'Bill details',
          fontSize: 16.r,
          fontWeight: FontWeight.w600,
        ),
        SizedBox(height: 12.w),
        CustomContainer(
          radiusAll: 16.r,
          horizontalMargin: 16.r,
          color: context.colors.background,
          boxShadow: [
            BoxShadow(
              color: context.colors.black.withValues(alpha: 0.03),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
          child: Column(
            children: [
              _buildBillRow(context, 'Total Items', '$itemCount'),
              if (minOrderAmount > 0)
                _buildBillRow(context, 'Min Order Amount', '৳${minOrderAmount.toStringAsFixed(0)}'),
              _buildBillRow(
                context,
                'Subtotal',
                '৳${itemTotal.toStringAsFixed(0)}',
                valueColor: context.colors.primary,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBillRow(
    BuildContext context,
    String title,
    String amount, {
    FontWeight? fontWeight,
    Color? valueColor,
  }) {
    return CustomContainer(
      paddingAll: 16.r,
      border: Border(bottom: BorderSide(color: context.colors.borderTertiary)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: title,
            fontWeight: fontWeight ?? FontWeight.w400,
            color: context.colors.textPrimary,
          ),
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
