import 'package:cheering/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_theme_colors.dart';
import '../../../domain/entities/address_entity.dart';

class SaveAsTypeSelector extends StatelessWidget {
  const SaveAsTypeSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final AddressType selected;
  final ValueChanged<AddressType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Save As',
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: context.colors.textSecondary,
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _TypeChip(
                label: 'Home',
                icon: Icons.home_outlined,
                selected: selected == AddressType.home,
                onTap: () => onChanged(AddressType.home),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: _TypeChip(
                label: 'Work',
                icon: Icons.work_outline_rounded,
                selected: selected == AddressType.work,
                onTap: () => onChanged(AddressType.work),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: _TypeChip(
                label: 'Other',
                selected: selected == AddressType.other,
                onTap: () => onChanged(AddressType.other),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.label,
    this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = selected
        ? context.colors.primary.withValues(alpha: 0.12)
        : context.colors.bgSecondary;
    final fg = selected
        ? context.colors.primary
        : context.colors.textSecondary;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(12.r),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18.r, color: fg),
                SizedBox(width: 6.w),
              ],
              CustomText(
                text: label,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: fg,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
