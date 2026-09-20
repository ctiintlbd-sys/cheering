import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/router/app_router_notifier.dart';
import '../../../../core/storage/onboarding_storage.dart';
import '../../../authentication/domain/usecases/check_stored_session_usecase.dart';
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
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final isOnboardingSeen = OnboardingStorage.isOnboardingCompleted;
    final isAuthenticated = await getIt<CheckStoredSessionUseCase>()();
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
            Assets.icons.appLogo.svg(width: 61.w, height: 57.w),
            CustomText(
              top: 16.w,
              text: 'CHEERING',
              fontSize: 20.r,
              fontWeight: FontWeight.w700,
              color: context.colors.textPrimary,
            ),
            CustomText(
              top: 4.w,
              text: context.l10n.splashSubtitle,
              fontWeight: FontWeight.w500,
              fontSize: 14.r,
              color: context.colors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
