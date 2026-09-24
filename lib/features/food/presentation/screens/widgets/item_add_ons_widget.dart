import 'package:cheering/features/food/domain/entities/menu_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/core/common_widgets/quantity_button.dart';

class ItemAddOnsWidget extends StatelessWidget {
  final List<MenuAddOnEntity> addOns;
  final List<MenuAddOnEntity> selectedAddOns;
  final ValueChanged<MenuAddOnEntity> onIncrement;
  final ValueChanged<MenuAddOnEntity> onDecrement;

  const ItemAddOnsWidget({
    super.key,
    required this.addOns,
    required this.selectedAddOns,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomText(
          top: 6.r,
          text: 'Add-ons',
          fontSize: 12.r,
          fontWeight: FontWeight.w500,
          color: context.colors.textTertiary,
        ),
        CustomContainer(
          verticalMargin: 12.w,
          color: context.colors.background,
          child: Column(
            children: List.generate(
              addOns.length,
                  (i) => _buildAddOnTile(context, i),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddOnTile(BuildContext context, int index) {
    final addOn = addOns[index];
    final count = selectedAddOns.where((a) => a.id == addOn.id).length;

    return Padding(
      padding: EdgeInsets.only(bottom: 16.w),
      child: Row(
        children: [
          Expanded(
            child: CustomText(text: addOn.name, fontWeight: FontWeight.w600),
          ),
          SizedBox(width: 16.w),
          CustomText(
            text: '+৳${addOn.price.toStringAsFixed(0)}',
            fontSize: 16.r,
            //color: context.colors.textTertiary,
          ),
          SizedBox(width: 14.w),
          QuantityButton(
            count: count,
            onIncrement: () => onIncrement(addOn),
            onDecrement: () => onDecrement(addOn),
          ),
        ],
      ),
    );
  }
}