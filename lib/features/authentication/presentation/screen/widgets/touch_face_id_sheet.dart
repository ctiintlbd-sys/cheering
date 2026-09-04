import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TouchFaceIdSheet extends StatelessWidget {
  const TouchFaceIdSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 12.h),
        child: CustomContainer(
          paddingAll: 24.h,
          radiusAll: 16.r,
          color: context.colors.background,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Title ─────────────────────────────────────
              CustomText(
                top: 22.h,
                text: 'Touch ID for Cheering',
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
              // ── Subtitle ───────────────────────────────────
              CustomText(
                top: 4.h,
                text: 'Login in your account',
                color: context.colors.textSecondary,
              ),
              SizedBox(height: 20.h),

              // ── Fingerprint Icon ───────────────────────────
              CustomContainer(
                width: 64.r,
                height: 64.r,
                color: context.colors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                child: Center(
                  child: Assets.icons.touch.svg(
                    width: 54.r,
                    height: 54.r,
                    color: context.colors.primary,
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // ── Cancel Button ──────────────────────────────
              CustomButton(
                backgroundColor: context.colors.background,
                foregroundColor: context.colors.textPrimary,
                bordersColor: context.colors.borderPrimary,
                onPressed: () {},
                label: 'Cancel',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
