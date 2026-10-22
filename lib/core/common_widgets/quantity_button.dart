import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum QuantityButtonSize {
  small,
  medium,
  big
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

  const QuantityButton.big({
    super.key,
    required this.count,
    required this.onIncrement,
    required this.onDecrement,
    this.iconSize,
    this.fontSize,
    this.paddingAll,
  }) : size = QuantityButtonSize.big;

  bool get _hasQuantity => (count ?? 0) > 0;

  T _bySize<T>({required T small, required T medium, required T big}) {
    switch (size) {
      case QuantityButtonSize.small:
        return small;
      case QuantityButtonSize.medium:
        return medium;
      case QuantityButtonSize.big:
        return big;
    }
  }

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
    final effectiveAddPadding =
        paddingAll ?? _bySize(small: 3.r, medium: 4.r, big: 6.r);
    final effectiveAddIconSize =
        iconSize ?? _bySize(small: 16.r, medium: 20.r, big: 26.r);
    final borderWidth = _bySize(small: 1.0, medium: 1.5, big: 2.0);
    return CustomContainer(
      onTap: () {
        HapticFeedback.lightImpact();
        onIncrement.call();
      },
      paddingAll: effectiveAddPadding,
      shape: BoxShape.circle,
      bordersColor: context.colors.borderSecondary,
      borderWidth: borderWidth,
      child: Icon(
        Icons.add,
        color: context.colors.primary,
        size: effectiveAddIconSize,
      ),
    );
  }

  Widget _buildQuantityControl(BuildContext context) {
    final isDelete = (count ?? 0) <= 1;
    final effectiveIconSize =
        iconSize ?? _bySize(small: 14.r, medium: 16.r, big: 22.r);
    final effectiveButtonPadding =
        paddingAll ?? _bySize(small: 4.r, medium: 5.r, big: 8.r);
    final buttonRadius = _bySize(small: 4.r, medium: 6.r, big: 10.r);
    final containerRadius = _bySize(small: 6.r, medium: 8.r, big: 12.r);
    final effectiveFontSize =
        fontSize ?? _bySize(small: 12.r, medium: 14.r, big: 18.r);
    final textFontWeight = _bySize(
      small: FontWeight.w600,
      medium: FontWeight.w500,
      big: FontWeight.w600,
    );
    final horizontalPadding = _bySize(small: 6.w, medium: 8.w, big: 14.w);
    final containerPadding = _bySize(small: 2.r, medium: 2.r, big: 3.r);

    return CustomContainer(
      color: context.colors.bgTertiary,
      radiusAll: containerRadius,
      paddingAll: containerPadding,
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