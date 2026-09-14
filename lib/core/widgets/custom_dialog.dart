import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cheering/core/widgets/widgets.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String? description;
  final String? buttonLabel;
  final Color? buttonBgColor;
  final Color? buttonLabelColor;
  final Color? titleColor;
  final Widget? content;
  final Widget? icon;
  final VoidCallback onTapButton;
  final bool isLoading;

  const CustomDialog({
    super.key,
    required this.title,
    this.buttonLabel = "Confirm",
    required this.onTapButton,
    this.buttonBgColor,
    this.buttonLabelColor = Colors.white,
    this.description,
    this.content,
    this.titleColor,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedTitleColor = titleColor ?? context.colors.textPrimary;
    final resolvedBgColor = buttonBgColor ?? context.colors.primary;

    return Dialog(
      backgroundColor: context.colors.background,
      insetPadding: EdgeInsets.symmetric(horizontal: 44.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[icon!, SizedBox(height: 24.h)],
                CustomText(
                  text: title,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.center,
                  color: resolvedTitleColor,
                ),
                //SizedBox(height: 8.h),
                if (description != null)
                  CustomText(
                    top: 8.h,
                    textAlign: TextAlign.center,
                    text: description!,
                    color: context.colors.textTertiary,
                  ),
                if (content != null) ...[SizedBox(height: 24.h), content!],
                SizedBox(height: 24.h),
                CustomButton(
                  height: 48.h,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  backgroundColor: resolvedBgColor,
                  foregroundColor: buttonLabelColor,
                  onPressed: isLoading
                      ? null
                      : () {
                          onTapButton.call();
                        },
                  label: buttonLabel!,
                ),
              ],
            ),
          ),
          if (isLoading)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(40.r),
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    color: context.colors.primary,
                    strokeWidth: 2.5,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
