import 'package:cheering/features/food/domain/entities/menu_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cheering/core/widgets/widgets.dart';

class ItemAddOnsWidget extends StatelessWidget {
  final List<MenuAddOnEntity> addOns;
  final Map<int, bool> selectedAddOns;
  final ValueChanged<int> onToggle;

  const ItemAddOnsWidget({
    super.key,
    required this.addOns,
    required this.selectedAddOns,
    required this.onToggle,
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
    final isChecked = selectedAddOns[index] ?? false;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onToggle(index),
      child: Padding(
        padding: EdgeInsets.only(bottom: 16.w),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: addOn.name, fontWeight: FontWeight.w600),
                  SizedBox(height: 4.w),
                  CustomText(
                    text: '+৳${addOn.price.toStringAsFixed(0)}',
                    fontSize: 12.r,
                    color: context.colors.textTertiary,
                  ),
                ],
              ),
            ),
            SizedBox(width: 14.w),
            CustomContainer(
              width: 20.r,
              height: 20.r,
              color: isChecked ? context.colors.primary : context.colors.white,
              radiusAll: 4.r,
              bordersColor: isChecked
                  ? context.colors.primary
                  : context.colors.borderSecondary,
              child: isChecked
                  ? Icon(Icons.check, size: 14.r, color: context.colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}