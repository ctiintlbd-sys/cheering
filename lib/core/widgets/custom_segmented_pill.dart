import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cheering/core/widgets/widgets.dart';

/// Ultra-smooth sliding animated segmented pill control.
/// Works with any generic data type [T].
class CustomSegmentedPill<T> extends StatelessWidget {
  final List<T> items;
  final T selectedValue;
  final String Function(T item) itemLabel;
  final ValueChanged<T> onChanged;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? thumbColor;
  final Duration animationDuration;
  final Curve animationCurve;

  const CustomSegmentedPill({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.itemLabel,
    required this.onChanged,
    this.height,
    this.padding,
    this.backgroundColor,
    this.thumbColor,
    this.animationDuration = const Duration(milliseconds: 250),
    this.animationCurve = Curves.easeOutCubic,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final colors = context.colors;
    final selectedIndex = items.indexOf(selectedValue);
    final validIndex = selectedIndex >= 0 ? selectedIndex : 0;

    final alignmentX = items.length <= 1
        ? 0.0
        : -1.0 + (2.0 / (items.length - 1)) * validIndex;

    return CustomContainer(
      height: height,
      paddingAll: 3.r,
      radiusAll: 99.r,
      color: backgroundColor ?? colors.bgTertiary,
      child: Stack(
        children: [
          // ── 1. Sliding Animated Indicator ──
          Positioned.fill(
            child: AnimatedAlign(
              alignment: Alignment(alignmentX, 0.0),
              duration: animationDuration,
              curve: animationCurve,
              child: FractionallySizedBox(
                widthFactor: 1.0 / items.length,
                heightFactor: 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: thumbColor ?? colors.white,
                    borderRadius: BorderRadius.circular(99.r),
                    boxShadow: [
                      BoxShadow(
                        color: colors.black.withValues(alpha: 0.06),
                        offset: const Offset(0, 2),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── 2. Interactive Item Buttons ──
          Row(
            children: items.map((item) {
              final isSelected = item == selectedValue;
              final label = itemLabel(item);

              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (item != selectedValue) {
                      onChanged(item);
                    }
                  },
                  child: Container(
                    padding: padding ??
                        EdgeInsets.symmetric(
                          vertical: 8.h,
                          horizontal: 8.w,
                        ),
                    alignment: Alignment.center,
                    child: AnimatedDefaultTextStyle(
                      duration: animationDuration,
                      curve: animationCurve,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: 'Inter',
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected
                            ? colors.textPrimary
                            : colors.textSecondary,
                      ),
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
