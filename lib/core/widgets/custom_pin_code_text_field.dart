import 'package:cheering/core/theme/app_theme_colors.dart';
import 'package:cheering/core/utils/assets/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

/// Ultra-smooth, high-performance, theme-reactive PinCode input widget.
/// - Integrated Haptic Feedback on digit entry.
/// - Filtered strictly for numeric digits.
/// - Zero frame-drops with RepaintBoundary optimization.
/// - Full color, font, box size, and border customization.
class CustomPinCodeTextField extends StatelessWidget {
  const CustomPinCodeTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.length = 4,
    this.validator,
    this.onChanged,
    this.onCompleted,
    this.onSubmitted,
    this.autoFocus = true,
    this.enabled = true,
    this.readOnly = false,
    // ── Dimensions & Shape ───────────────────────────────────────
    this.boxWidth = 56,
    this.boxHeight = 56,
    this.borderRadius = 12,
    this.borderWidth = 1.0,
    this.focusedBorderWidth = 1.5,
    // ── Colors ───────────────────────────────────────────────────
    this.textColor,
    this.fillColor,
    this.focusedFillColor,
    this.submittedFillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.cursorColor,
    // ── Typography ───────────────────────────────────────────────
    this.fontSize = 22,
    this.fontWeight = FontWeight.w600,
    this.fontFamily,
    // ── Obscure ──────────────────────────────────────────────────
    this.obscureText = false,
    this.obscuringCharacter = '•',
    this.obscuringWidget,
    this.hapticFeedbackType = HapticFeedbackType.lightImpact,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final int length;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final ValueChanged<String>? onSubmitted;
  final bool autoFocus;
  final bool enabled;
  final bool readOnly;

  // Dimensions
  final double boxWidth;
  final double boxHeight;
  final double borderRadius;
  final double borderWidth;
  final double focusedBorderWidth;

  // Colors
  final Color? textColor;
  final Color? fillColor;
  final Color? focusedFillColor;
  final Color? submittedFillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final Color? cursorColor;

  // Typography
  final double fontSize;
  final FontWeight fontWeight;
  final String? fontFamily;

  // Obscure & Feedback
  final bool obscureText;
  final String obscuringCharacter;
  final Widget? obscuringWidget;
  final HapticFeedbackType hapticFeedbackType;

  @override
  Widget build(BuildContext context) {
    final effectiveFont = fontFamily ?? FontFamily.sFPro;
    final effectiveRadius = BorderRadius.circular(borderRadius.r);
    final effectiveTextColor = textColor ?? context.colors.textPrimary;
    final effectiveFillColor = fillColor ?? context.colors.bgTertiary;
    final effectiveFocusedFill = focusedFillColor ?? context.colors.bgSecondary;
    final effectiveSubmittedFill = submittedFillColor ?? context.colors.bgTertiary;
    final effectiveBorder = borderColor ?? Colors.transparent;
    final effectiveFocusedBorder = focusedBorderColor ?? context.colors.primary;
    final effectiveErrorBorder = errorBorderColor ?? context.colors.error;
    final effectiveCursorColor = cursorColor ?? context.colors.primary;

    final defaultTheme = PinTheme(
      width: boxWidth.w,
      height: boxHeight.h,
      textStyle: TextStyle(
        fontFamily: effectiveFont,
        fontWeight: fontWeight,
        fontSize: fontSize.sp,
        color: effectiveTextColor,
      ),
      decoration: BoxDecoration(
        color: effectiveFillColor,
        borderRadius: effectiveRadius,
        border: Border.all(
          color: effectiveBorder,
          width: borderWidth,
        ),
      ),
    );

    final focusedTheme = defaultTheme.copyWith(
      decoration: defaultTheme.decoration?.copyWith(
        color: effectiveFocusedFill,
        border: Border.all(
          color: effectiveFocusedBorder,
          width: focusedBorderWidth,
        ),
      ),
    );

    final submittedTheme = defaultTheme.copyWith(
      decoration: defaultTheme.decoration?.copyWith(
        color: effectiveSubmittedFill,
        border: Border.all(
          color: Colors.transparent,
          width: borderWidth,
        ),
      ),
    );

    final errorTheme = defaultTheme.copyWith(
      decoration: defaultTheme.decoration?.copyWith(
        color: effectiveFocusedFill,
        border: Border.all(
          color: effectiveErrorBorder,
          width: focusedBorderWidth,
        ),
      ),
    );

    return RepaintBoundary(
      child: Pinput(
        controller: controller,
        focusNode: focusNode,
        length: length,
        autofocus: autoFocus,
        enabled: enabled,
        readOnly: readOnly,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        hapticFeedbackType: hapticFeedbackType,
        obscureText: obscureText,
        obscuringCharacter: obscuringCharacter,
        obscuringWidget: obscuringWidget,
        defaultPinTheme: defaultTheme,
        focusedPinTheme: focusedTheme,
        submittedPinTheme: submittedTheme,
        errorPinTheme: errorTheme,
        validator: validator,
        onChanged: onChanged,
        onCompleted: onCompleted,
        onSubmitted: onSubmitted,
        showCursor: true,
        cursor: Center(
          child: Container(
            width: 2.w,
            height: 22.h,
            decoration: BoxDecoration(
              color: effectiveCursorColor,
              borderRadius: BorderRadius.circular(1.r),
            ),
          ),
        ),
      ),
    );
  }
}
