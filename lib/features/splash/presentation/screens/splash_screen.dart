import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/router/app_router_notifier.dart';
import '../../../../core/storage/biometric_device_storage.dart';
import '../../../../core/storage/biometric_storage.dart';
import '../../../../core/storage/onboarding_storage.dart';
import '../../../authentication/domain/usecases/check_stored_session_usecase.dart';
import '../../../authentication/domain/usecases/clear_local_session_usecase.dart';
import '../../../../core/utils/assets/assets.gen.dart';
import '../../../../core/widgets/widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    // Minimum splash display duration
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final isOnboardingSeen = OnboardingStorage.isOnboardingCompleted;
    if (!isOnboardingSeen) {
      await getIt<ClearLocalSessionUseCase>()();
      await BiometricStorage.clear();
      await BiometricDeviceStorage.clear();
    }
    final isAuthenticated = isOnboardingSeen
        ? await getIt<CheckStoredSessionUseCase>()()
        : false;

    getIt<AppRouterNotifier>().updateAuth(
      isAuthenticated: isAuthenticated,
      isOnboardingSeen: isOnboardingSeen,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Assets.icons.appLogo.svg(width: 61.w, height: 57.h),
            CustomText(
              top: 16.h,
              text: 'CHEERING',
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: context.colors.textPrimary,
            ),
            CustomText(
              top: 4.h,
              text: context.l10n.splashSubtitle,
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
              color: context.colors.primary,
            ),
          ],
        ),
      ),
    );
  }
}