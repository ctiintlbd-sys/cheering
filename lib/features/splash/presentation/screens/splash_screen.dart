import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/router/app_router_notifier.dart';
import '../../../../core/storage/token_storage.dart';
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

    final isAuthenticated = TokenStorage.accessToken != null;

    getIt<AppRouterNotifier>().updateAuth(
      isAuthenticated: isAuthenticated,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: Center(
        child: Assets.icons.appLogo.svg(width: 171.w, height: 52.h),
      ),
    );
  }
}