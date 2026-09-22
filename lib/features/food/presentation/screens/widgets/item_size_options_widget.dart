import 'package:cheering/features/food/domain/entities/menu_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cheering/core/widgets/widgets.dart';

class ItemSizeOptionsWidget extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final List<MenuVariantEntity> variants;

  const ItemSizeOptionsWidget({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
    required this.variants,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          top: 24.r,
          text: 'Choose Variant',
          fontSize: 12.r,
          fontWeight: FontWeight.w500,
          color: context.colors.textTertiary,
        ),
        CustomContainer(
          verticalMargin: 12.w,
          color: context.colors.white,
          radiusAll: 16.r,
          border: Border.all(color: context.colors.borderSecondary),
          child: Column(
            children: List.generate(
              variants.length,
              (i) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTile(context, i),
                  if (i < variants.length - 1)
                    Divider(height: 1, color: context.colors.borderSecondary),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTile(BuildContext context, int index) {
    final variant = variants[index];
    final isSelected = selectedIndex == index;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged(index),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text: variant.name, fontWeight: FontWeight.w600),
                SizedBox(height: 4.w),
                CustomText(
                  text: '৳${variant.price.toStringAsFixed(0)}',
                  fontSize: 12.r,
                  color: context.colors.textTertiary,
                ),
              ],
            ),
            CustomContainer(
              width: 20.r,
              height: 20.r,
              shape: BoxShape.circle,
              color: context.colors.white,
              borderWidth: isSelected ? 7 : 2,
              bordersColor: isSelected
                  ? context.colors.primary
                  : context.colors.borderSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
