import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomFilterChip extends StatelessWidget {
  final String label;
  final double? labelSize;
  final bool isSelected;
  final VoidCallback onTap;
  final EdgeInsetsGeometry? padding;

  const CustomFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap, this.padding, this.labelSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        margin: EdgeInsets.symmetric(vertical: 4.h),
        decoration: BoxDecoration(
          color: isSelected
              ? context.colors.primary
              : context.colors.background,
          borderRadius: BorderRadius.circular(44.r),
          border: isSelected
              ? null
              : Border.all(color: context.colors.borderTertiary),
        ),
        child: Center(
          child: CustomText(
            text: label,
            fontSize: labelSize ?? 12.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            maxLines: 1,
            color: isSelected
                ? context.colors.white
                : context.colors.textSecondary,
          ),
        ),
      ),
    );
  }
}
