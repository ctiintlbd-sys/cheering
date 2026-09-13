import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/helpers/toast_message_helper.dart';
import '../../../../core/router/app_router_notifier.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/utils/assets/assets.gen.dart';
import '../../../../core/widgets/app_auth_title.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/services/biometric_service.dart';

class EnableBiometricsScreen extends StatefulWidget {
  const EnableBiometricsScreen({super.key});

  @override
  State<EnableBiometricsScreen> createState() => _EnableBiometricsScreenState();
}

class _EnableBiometricsScreenState extends State<EnableBiometricsScreen> {
  bool _isLoading = false;

  Future<void> _onEnableBiometrics() async {
    setState(() => _isLoading = true);
    final biometricService = getIt<BiometricService>();

    final isAvailable = await biometricService.isBiometricsAvailable();
    if (!isAvailable) {
      ToastMessageHelper.show('Biometrics is not available on this device.');
      if (mounted) {
        getIt<AppRouterNotifier>().updateAuth(isAuthenticated: true);
        context.go(RoutePaths.foodTab);
      }
      return;
    }

    final success = await biometricService.authenticate(
      localizedReason: 'Please authenticate to enable biometric login for Cheering',
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      await biometricService.setBiometricEnabled(true);
      ToastMessageHelper.show('Biometric login enabled successfully!');
      if (mounted) {
        getIt<AppRouterNotifier>().updateAuth(isAuthenticated: true);
        context.go(RoutePaths.foodTab);
      }
    } else {
      ToastMessageHelper.show('Biometric verification cancelled or failed.');
    }
  }

  void _onMaybeLater() {
    getIt<BiometricService>().setBiometricEnabled(false);
    getIt<AppRouterNotifier>().updateAuth(isAuthenticated: true);
    context.go(RoutePaths.foodTab);
  }

  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      sideContentPadding: 24.w,
      appBar: CustomSliverAppBar(
        backgroundColor: context.colors.background.withValues(alpha: 0.4),
        expandedHeight: 180.h,
        flexibleChild: AppAuthTitle(
          title: 'Enable Touch ID / Face ID',
          subtitle:
              'Enable biometric login for faster, more secure access to your account.',
        ),
      ),
      bodyList: [
        SizedBox(height: 16.h),

        CustomContainer(
          height: 120.r,
          width: 120.r,
          shape: BoxShape.circle,
          child: Assets.icons.face.svg(),
        ),

        SizedBox(height: 24.h),

        CustomButton(
          label: 'Enable Biometrics',
          isLoading: _isLoading,
          onPressed: _onEnableBiometrics,
        ),

        SizedBox(height: 12.h),

        CustomButton(
          bordersColor: context.colors.borderPrimary,
          backgroundColor: context.colors.background,
          foregroundColor: context.colors.textPrimary,
          label: 'Maybe Later',
          onPressed: _onMaybeLater,
        ),
      ],
    );
  }
}
