import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BillDetailsCard extends StatelessWidget {
  const BillDetailsCard({super.key});

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
              _buildBillRow(context, 'Item total', '৳1,259'),
              _buildBillRow(context, 'Delivery fee', '৳40'),
              _buildBillRow(
                context,
                'Discount',
                '-৳200',
                valueColor: context.colors.bgSuccessSecondary,
              ),
              _buildBillRow(
                context,
                'Delivery fee',
                '৳1,099',
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
