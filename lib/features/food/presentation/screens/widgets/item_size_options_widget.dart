import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cheering/core/widgets/widgets.dart';

class ItemSizeOptionsWidget extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const ItemSizeOptionsWidget({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          top: 24.r,
          text: 'Choose size',
          fontSize: 12.r,
          fontWeight: FontWeight.w500,
          color: context.colors.textTertiary,
        ),
        CustomContainer(
          verticalMargin: 12.w,
          color: context.colors.white,
          radiusAll: 16.r,
          bordersColor: context.colors.borderSecondary,
          border: Border.all(color: context.colors.borderSecondary),
          child: Column(
            children: [
              _buildSizeOptionTile(
                context: context,
                index: 0,
                title: '6 pcs',
                subtitle: 'Serves 1-2',
              ),
              Divider(height: 1, color: context.colors.borderSecondary),
              _buildSizeOptionTile(
                context: context,
                index: 1,
                title: '8 pcs',
                subtitle: 'Serves 2-3 · Most popular',
              ),
              Divider(height: 1, color: context.colors.borderSecondary),
              _buildSizeOptionTile(
                context: context,
                index: 2,
                title: '12 pcs',
                subtitle: 'Serves 3-4',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSizeOptionTile({
    required BuildContext context,
    required int index,
    required String title,
    required String subtitle,
  }) {
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
                CustomText(text: title, fontWeight: FontWeight.w600),
                SizedBox(height: 4.w),
                CustomText(
                  text: subtitle,
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
