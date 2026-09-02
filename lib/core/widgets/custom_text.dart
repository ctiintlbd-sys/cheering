import 'package:cheering/core/theme/app_theme_colors.dart';
import 'package:cheering/core/utils/assets/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Ultra-optimized, ergonomic CustomText widget for clean Figma UI design.
/// - Zero unnecessary widget tree nesting (No Padding if margins are 0).
/// - Zero unnecessary gesture wrapper (No GestureDetector if onTap is null).
/// - Auto TextOverflow.ellipsis when maxline is specified.
/// - Auto theme-aware color (context.colors.textPrimary) & SF-Pro typography.
/// - Decoration conflict guarded via assert (debug mode only).
/// - Padding detection uses != 0 to support edge-case negative values.
class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    this.fontSize,
    this.fontWeight = FontWeight.w400,
    this.color,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.textOverflow,
    this.fontName,
    this.textHeight,
    this.letterSpacing,
    this.fontStyle,
    this.isUnderline = false,
    this.isLineThrough = false,
    this.decoration,
    this.decorationColor,
    this.shadows,
    this.softWrap = true,
    this.onTap,
    this.padding,
    this.left = 0,
    this.right = 0,
    this.top = 0,
    this.bottom = 0,
  }) : assert(
  !(isUnderline && isLineThrough),
  'CustomText: isUnderline and isLineThrough cannot both be true. '
      'Pick one, or use the decoration parameter directly.',
  );

  final String text;
  final double? fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow? textOverflow;
  final String? fontName;
  final double? textHeight;
  final double? letterSpacing;
  final FontStyle? fontStyle;
  final bool isUnderline;
  final bool isLineThrough;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final List<Shadow>? shadows;
  final bool softWrap;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final double left;
  final double right;
  final double top;
  final double bottom;

  // FIX: Using != 0 instead of > 0 to correctly detect negative padding values
  bool get _hasPadding =>
      padding != null || left != 0 || right != 0 || top != 0 || bottom != 0;

  // FIX: explicit decoration takes priority over bool flags
  // isUnderline + isLineThrough both true is caught by the constructor assert (debug only)
  TextDecoration? get _resolvedDecoration {
    if (decoration != null) return decoration;
    if (isUnderline) return TextDecoration.underline;
    if (isLineThrough) return TextDecoration.lineThrough;
    return null;
  }

  TextOverflow? get _resolvedOverflow {
    if (textOverflow != null) return textOverflow;
    if (maxLines != null) return TextOverflow.ellipsis;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // FIX: resolve color once — avoids calling context.colors.textPrimary
    // twice (previously done separately for color and decorationColor)
    final resolvedColor = color ?? context.colors.textPrimary;

    Widget current = Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: _resolvedOverflow,
      softWrap: softWrap,
      style: TextStyle(
        fontSize: fontSize ?? 14.sp,
        fontFamily: fontName ?? FontFamily.sFPro,
        fontWeight: fontWeight,
        color: resolvedColor,
        height: textHeight,
        letterSpacing: letterSpacing,
        fontStyle: fontStyle,
        decoration: _resolvedDecoration,
        decorationColor: decorationColor ?? resolvedColor,
        shadows: shadows,
      ),
    );

    // ── Performance: Only wrap in Padding if spacing is actually requested
    if (_hasPadding) {
      current = Padding(
        padding: padding ??
            EdgeInsets.only(
              left: left.w,
              right: right.w,
              top: top.h,
              bottom: bottom.h,
            ),
        child: current,
      );
    }

    // ── Performance: Only wrap in GestureDetector if onTap listener is passed
    if (onTap != null) {
      current = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: current,
      );
    }

    return current;
  }
}