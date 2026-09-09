import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuantityButton extends StatelessWidget {
  final int? count;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const QuantityButton({
    super.key,
    required this.count,
    required this.onIncrement,
    required this.onDecrement,
  });

  bool get _hasQuantity => (count ?? 0) > 0;

  @override
  Widget build(BuildContext context) {
    return _hasQuantity
        ? _buildQuantityControl(context)
        : _buildAddButton(context);
  }

  Widget _buildAddButton(BuildContext context) {
    return GestureDetector(
      onTap: onIncrement,
      child: CustomContainer(
        paddingAll: 4.r,
        shape: BoxShape.circle,
        bordersColor: context.colors.borderSecondary,
        borderWidth: 1.5,
        child: Icon(
          Icons.add,
          color: context.colors.primary,
          size: 20.r,
        ),
      ),
    );
  }

  Widget _buildQuantityControl(BuildContext context) {
    return CustomContainer(
      color: context.colors.bgTertiary,
      radiusAll: 8.r,
      paddingAll: 2.r,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomContainer(
            onTap: onDecrement,
            paddingAll: 5.r,
            radiusAll: 6,
            color: context.colors.background,
            child: Icon(
              Icons.remove,
              color: context.colors.textSecondary,
              size: 16.r,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: CustomText(
              text: '$count',
              fontWeight: FontWeight.w500,
            ),
          ),
          CustomContainer(
            onTap: onIncrement,
            paddingAll: 5.r,
            radiusAll: 6,
            color: context.colors.primary,
            child: Icon(
              Icons.add,
              color: context.colors.white,
              size: 16.r,
            ),
          ),
        ],
      ),
    );
  }
}