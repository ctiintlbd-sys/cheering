import 'package:cheering/core/common_widgets/quantity_button.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../domain/entities/cart_add_on_entity.dart';

class CartItemAddOnsWidget extends StatelessWidget {
  final List<CartAddOnEntity> addOns;
  final void Function(String addOnId, int quantity)? onUpdateAddOnQuantity;

  const CartItemAddOnsWidget({
    super.key,
    required this.addOns,
    this.onUpdateAddOnQuantity,
  });

  @override
  Widget build(BuildContext context) {
    if (addOns.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: 10.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.w),
        decoration: BoxDecoration(
          color: context.colors.bgSecondary,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'Add-ons',
              fontSize: 11.r,
              fontWeight: FontWeight.w600,
              color: context.colors.textSecondary,
              bottom: 6.w,
            ),
            ...addOns.map((addOn) => _buildAddOnItem(context, addOn)),
          ],
        ),
      ),
    );
  }

  Widget _buildAddOnItem(BuildContext context, CartAddOnEntity addOn) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.w),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: addOn.name,
                  fontSize: 13.r,
                  fontWeight: FontWeight.w500,
                ),
                if (addOn.unitPrice > 0)
                  CustomText(
                    text: '+৳${(addOn.unitPrice * addOn.quantity).toStringAsFixed(0)}',
                    fontSize: 11.r,
                    color: context.colors.textTertiary,
                  ),
              ],
            ),
          ),
          QuantityButton.small(
            count: addOn.quantity,
            onIncrement: () {
              onUpdateAddOnQuantity?.call(addOn.id, addOn.quantity + 1);
            },
            onDecrement: () {
              onUpdateAddOnQuantity?.call(addOn.id, addOn.quantity - 1);
            },
          ),
        ],
      ),
    );
  }
}
