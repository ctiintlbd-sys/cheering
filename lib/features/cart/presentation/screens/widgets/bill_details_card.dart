import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BillDetailsCard extends StatelessWidget {
  final double itemTotal;
  final int itemCount;
  final double minOrderAmount;
  final double? deliveryFee;
  final double? priorityFee;
  final double? taxAmount;
  final double? platformFee;
  final double? discount;
  final double? tip;
  final double? grandTotal;

  const BillDetailsCard({
    super.key,
    required this.itemTotal,
    required this.itemCount,
    required this.minOrderAmount,
    this.deliveryFee,
    this.priorityFee,
    this.taxAmount,
    this.platformFee,
    this.discount,
    this.tip,
    this.grandTotal,
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
              if (grandTotal == null)
                _buildBillRow(context, 'Total Items', '$itemCount'),
              if (minOrderAmount > 0)
                _buildBillRow(context, 'Min Order Amount', '৳${minOrderAmount.toStringAsFixed(0)}'),
              _buildBillRow(
                context,
                grandTotal != null ? 'Item total' : 'Subtotal',
                '৳${itemTotal.toStringAsFixed(0)}',
                valueColor: grandTotal != null ? context.colors.textPrimary : context.colors.primary,
                fontWeight: grandTotal != null ? FontWeight.w400 : FontWeight.w600,
              ),
              if (deliveryFee != null && deliveryFee! > 0)
                _buildBillRow(context, 'Delivery fee', '৳${deliveryFee!.toStringAsFixed(0)}'),
              if (priorityFee != null && priorityFee! > 0)
                _buildBillRow(context, 'Priority fee', '৳${priorityFee!.toStringAsFixed(0)}'),
              if (taxAmount != null && taxAmount! > 0)
                _buildBillRow(context, 'Tax', '৳${taxAmount!.toStringAsFixed(0)}'),
              if (platformFee != null && platformFee! > 0)
                _buildBillRow(context, 'Platform fee', '৳${platformFee!.toStringAsFixed(0)}'),
              if (tip != null && tip! > 0)
                _buildBillRow(context, 'Rider tip', '৳${tip!.toStringAsFixed(0)}'),
              if (discount != null && discount! > 0)
                _buildBillRow(
                  context,
                  'Discount',
                  '-৳${discount!.toStringAsFixed(0)}',
                  valueColor: Colors.green,
                ),
              if (grandTotal != null)
                _buildBillRow(
                  context,
                  '$itemCount pcs',
                  '৳${grandTotal!.toStringAsFixed(0)}',
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
