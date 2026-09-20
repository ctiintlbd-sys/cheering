import 'package:cheering/core/theme/app_theme_colors.dart';
import 'package:cheering/core/utils/assets/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'custom_text.dart';

/// Ultra-smooth, theme-reactive, production-grade CustomButton.
/// - Native fluid ripple & touch feedback (Material + InkWell).
/// - Smooth animated loading spinner transition (Zero layout shift).
/// - Displays prefix/suffix icons automatically when provided.
class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    this.text,
    this.label,
    this.child,
    this.title,
    // ── Colors & Style ───────────────────────────────────────────
    this.backgroundColor,
    this.foregroundColor,
    this.textColor,
    this.bordersColor,
    this.borderWidth,
    // ── Dimensions & Radius ──────────────────────────────────────
    this.height,
    this.width,
    this.radius,
    this.borderRadius,
    this.padding,
    this.gap = 8,
    // ── Typography ───────────────────────────────────────────────
    this.fontSize,
    this.fontWeight = FontWeight.w500,
    this.fontName,
    // ── Icons ────────────────────────────────────────────────────
    this.prefixIcon,
    this.suffixIcon,
    // ── States & Indicators ──────────────────────────────────────
    this.isLoading = false,
    this.isDisabled = false,
    this.elevation = false,
    this.elevationValue,
    this.loadingIndicatorColor,
  });

  final VoidCallback? onPressed;
  final String? text;
  final String? label;
  final Widget? child;
  final Widget? title;

  // Colors & Style
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? textColor;
  final Color? bordersColor;
  final double? borderWidth;

  // Dimensions
  final double? height;
  final double? width;
  final double? radius;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double gap;

  // Typography
  final double? fontSize;
  final FontWeight fontWeight;
  final String? fontName;

  // Icons
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  // States
  final bool isLoading;
  final bool isDisabled;
  final bool elevation;
  final double? elevationValue;
  final Color? loadingIndicatorColor;

  String? get _effectiveText => text ?? label;

  double get _effectiveRadius => (radius ?? borderRadius ?? 48).r;

  Color? get _effectiveBorderColor => bordersColor;

  Color _resolveFgColor(BuildContext context, bool isTransparentBg) {
    if (textColor != null) return textColor!;
    if (foregroundColor != null) return foregroundColor!;
    if (isDisabled) return context.colors.textPlaceholder;
    if (isTransparentBg) return context.colors.textPrimary;
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final effectiveRadiusValue = _effectiveRadius;
    final isTransparent = backgroundColor == Colors.transparent;
    final defaultBg = isDisabled
        ? context.colors.outline
        : (backgroundColor ?? context.colors.primary);
    final effectiveFg = _resolveFgColor(context, isTransparent);
    final effectiveBorder = _effectiveBorderColor;

    final isInteractive = !isLoading && !isDisabled && onPressed != null;

    return RepaintBoundary(
      child: Material(
        color: defaultBg,
        elevation: elevation ? (elevationValue ?? 2.0) : 0.0,
        shadowColor: context.colors.primary.withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(effectiveRadiusValue),
          side: effectiveBorder != null
              ? BorderSide(color: effectiveBorder, width: borderWidth ?? 1.0)
              : BorderSide.none,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: isInteractive ? onPressed : null,
          splashColor: isTransparent
              ? context.colors.primary.withValues(alpha: 0.1)
              : Colors.white.withValues(alpha: 0.2),
          highlightColor: isTransparent
              ? context.colors.primary.withValues(alpha: 0.05)
              : Colors.white.withValues(alpha: 0.1),
          child: Container(
            height: height ?? 48.w,
            width: width ?? double.infinity,
            padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
            alignment: Alignment.center,
            child:
                child ??
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  switchInCurve: Curves.easeIn,
                  switchOutCurve: Curves.easeOut,
                  child: isLoading
                      ? SizedBox(
                          key: const ValueKey('button_loading'),
                          height: 20.w,
                          width: 20.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              loadingIndicatorColor ?? effectiveFg,
                            ),
                          ),
                        )
                      : Row(
                          key: const ValueKey('button_content'),
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Prefix Icon
                            if (prefixIcon != null) ...[
                              prefixIcon!,
                              SizedBox(width: gap.w),
                            ],

                            // Optional Title widget or Text
                            if (title != null) ...[
                              title!,
                            ] else if (_effectiveText != null) ...[
                              Flexible(
                                child: CustomText(
                                  text: _effectiveText!,
                                  color: effectiveFg,
                                  fontName: fontName ?? FontFamily.sFPro,
                                  fontWeight: fontWeight,
                                  fontSize: fontSize ?? 16.r,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                ),
                              ),
                            ],

                            // Suffix Icon
                            if (suffixIcon != null) ...[
                              SizedBox(width: gap.w),
                              suffixIcon!,
                            ],
                          ],
                        ),
                ),
          ),
        ),
      ),
    );
  }
}
