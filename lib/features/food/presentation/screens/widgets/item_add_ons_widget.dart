import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cheering/core/widgets/widgets.dart';

class ItemAddOnsWidget extends StatelessWidget {
  final Map<int, bool> selectedAddOns;
  final ValueChanged<int> onToggle;

  const ItemAddOnsWidget({
    super.key,
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
          top: 6.sp,
          text: 'Add-ons',
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: context.colors.textTertiary,
        ),
        CustomContainer(
          verticalMargin: 12.h,
          color: context.colors.background,
          child: Column(
            children: [
              _buildAddOnTile(
                context: context,
                index: 0,
                title: 'Extra dip sauce',
                subtitle: 'Garlic mayo or spicy ketchup',
                price: '+৳40',
              ),
              SizedBox(height: 8.h),
              _buildAddOnTile(
                context: context,
                index: 1,
                title: 'Cheese fries',
                subtitle: 'Regular fries topped with cheese',
                price: '+৳120',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddOnTile({
    required BuildContext context,
    required int index,
    required String title,
    required String subtitle,
    required String price,
  }) {
    final isChecked = selectedAddOns[index] ?? false;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onToggle(index),
      child: Padding(
        padding: EdgeInsets.only(bottom: 16.h),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: title, fontWeight: FontWeight.w600),
                  SizedBox(height: 4.h),
                  CustomText(
                    text: subtitle,
                    fontSize: 12.sp,
                    color: context.colors.textTertiary,
                  ),
                ],
              ),
            ),
            CustomText(text: price, fontSize: 16.sp),
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
