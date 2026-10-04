import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum QuantityButtonSize {
  small,
  medium,
}

class QuantityButton extends StatelessWidget {
  final int? count;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final QuantityButtonSize size;
  final double? iconSize;
  final double? fontSize;
  final double? paddingAll;

  const QuantityButton({
    super.key,
    required this.count,
    required this.onIncrement,
    required this.onDecrement,
    this.size = QuantityButtonSize.medium,
    this.iconSize,
    this.fontSize,
    this.paddingAll,
  });

  const QuantityButton.small({
    super.key,
    required this.count,
    required this.onIncrement,
    required this.onDecrement,
    this.iconSize,
    this.fontSize,
    this.paddingAll,
  }) : size = QuantityButtonSize.small;

  bool get _hasQuantity => (count ?? 0) > 0;

  static Widget _scaleFadeTransition(Widget child, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(scale: animation, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      transitionBuilder: _scaleFadeTransition,
      child: _hasQuantity
          ? KeyedSubtree(
        key: const ValueKey('quantity_control'),
        child: _buildQuantityControl(context),
      )
          : KeyedSubtree(
        key: const ValueKey('add_button'),
        child: _buildAddButton(context),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    final isSmall = size == QuantityButtonSize.small;
    final effectiveAddPadding = paddingAll ?? (isSmall ? 3.r : 4.r);
    final effectiveAddIconSize = iconSize ?? (isSmall ? 16.r : 20.r);
    return CustomContainer(
      onTap: () {
        HapticFeedback.lightImpact();
        onIncrement.call();
      },
      paddingAll: effectiveAddPadding,
      shape: BoxShape.circle,
      bordersColor: context.colors.borderSecondary,
      borderWidth: isSmall ? 1.0 : 1.5,
      child: Icon(
        Icons.add,
        color: context.colors.primary,
        size: effectiveAddIconSize,
      ),
    );
  }

  Widget _buildQuantityControl(BuildContext context) {
    final isSmall = size == QuantityButtonSize.small;
    final isDelete = (count ?? 0) <= 1;
    final effectiveIconSize = iconSize ?? (isSmall ? 14.r : 16.r);
    final effectiveButtonPadding = paddingAll ?? (isSmall ? 4.r : 5.r);
    final buttonRadius = isSmall ? 4.r : 6.r;
    final containerRadius = isSmall ? 6.r : 8.r;
    final effectiveFontSize = fontSize ?? (isSmall ? 12.r : 14.r);
    final textFontWeight = isSmall ? FontWeight.w600 : FontWeight.w500;
    final horizontalPadding = isSmall ? 6.w : 8.w;
    return CustomContainer(
      color: context.colors.bgTertiary,
      radiusAll: containerRadius,
      paddingAll: 2.r,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomContainer(
            onTap: () {
              HapticFeedback.lightImpact();
              onDecrement.call();
            },
            paddingAll: effectiveButtonPadding,
            radiusAll: buttonRadius,
            color: context.colors.background,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              transitionBuilder: _scaleFadeTransition,
              child: Icon(
                isDelete ? Icons.delete_outline_rounded : Icons.remove,
                key: ValueKey<bool>(isDelete),
                color: isDelete
                    ? context.colors.error
                    : context.colors.textSecondary,
                size: effectiveIconSize,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: CustomText(
              text: '$count',
              fontSize: effectiveFontSize,
              fontWeight: textFontWeight,
            ),
          ),
          CustomContainer(
            onTap: () {
              HapticFeedback.lightImpact();
              onIncrement.call();
            },
            paddingAll: effectiveButtonPadding,
            radiusAll: buttonRadius,
            color: context.colors.primary,
            child: Icon(
              Icons.add,
              color: context.colors.white,
              size: effectiveIconSize,
            ),
          ),
        ],
      ),
    );
  }
}