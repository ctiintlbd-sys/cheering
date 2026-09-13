import 'package:cheering/core/router/app_router_notifier.dart';
import 'package:cheering/core/storage/token_storage.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/helpers/toast_message_helper.dart';
import '../../../data/services/biometric_service.dart';

class TouchFaceIdSheet extends StatefulWidget {
  const TouchFaceIdSheet({super.key});

  @override
  State<TouchFaceIdSheet> createState() => _TouchFaceIdSheetState();
}

class _TouchFaceIdSheetState extends State<TouchFaceIdSheet> {
  @override
  void initState() {
    super.initState();
    // Prompt biometric authentication automatically after bottom sheet opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authenticate();
    });
  }

  Future<void> _authenticate() async {
    final biometricService = getIt<BiometricService>();

    final isAvailable = await biometricService.isBiometricsAvailable();
    if (!isAvailable) {
      ToastMessageHelper.show(
        'Biometrics is not available or enrolled on this device.',
      );
      if (mounted) Navigator.of(context).pop();
      return;
    }

    final hasSession = TokenStorage.refreshToken != null &&
        TokenStorage.refreshToken!.isNotEmpty;

    if (!hasSession) {
      ToastMessageHelper.show(
        'Please log in with password once before using Touch ID.',
      );
      if (mounted) Navigator.of(context).pop();
      return;
    }

    final authenticated = await biometricService.authenticate(
      localizedReason: 'Scan fingerprint to log in to Cheering',
    );

    if (authenticated) {
      if (mounted) Navigator.of(context).pop();
      getIt<AppRouterNotifier>().updateAuth(isAuthenticated: true);
    } else {
      ToastMessageHelper.show('Biometric authentication cancelled or failed.');
    }
  }

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
                text: 'Touch ID / Face ID',
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
              // ── Subtitle ───────────────────────────────────
              CustomText(
                top: 4.h,
                text: 'Log in to your Cheering account',
                color: context.colors.textSecondary,
              ),
              SizedBox(height: 20.h),

              // ── Fingerprint Icon Button ────────────────────
              GestureDetector(
                onTap: _authenticate,
                child: CustomContainer(
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
              ),
              SizedBox(height: 20.h),

              // ── Cancel Button ──────────────────────────────
              CustomButton(
                backgroundColor: context.colors.background,
                foregroundColor: context.colors.textPrimary,
                bordersColor: context.colors.borderPrimary,
                onPressed: () => Navigator.of(context).pop(),
                label: 'Cancel',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
