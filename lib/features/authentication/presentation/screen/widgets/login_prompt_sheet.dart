import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../../core/router/app_router_notifier.dart';
import '../../../../../core/router/route_paths.dart';
import '../../../../../core/widgets/widgets.dart';

class LoginPromptSheet extends StatelessWidget {
  final String title;
  final String subtitle;
  final String currentPath;

  const LoginPromptSheet({
    super.key,
    required this.currentPath,
    this.title = 'Login Required',
    this.subtitle = 'Please log in or sign up to continue.',
  });

  static void show(BuildContext context, {String? title, String? subtitle}) {
    final path = GoRouterState.of(context).uri.toString();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LoginPromptSheet(
        currentPath: path,
        title: title ?? 'Login Required',
        subtitle: subtitle ?? 'Please log in or sign up to continue.',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48.w,
              height: 4.w,
              decoration: BoxDecoration(
                color: context.colors.borderSecondary,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 24.w),
            CustomText(
              text: title,
              fontSize: 20.r,
              fontWeight: FontWeight.w700,
            ),
            SizedBox(height: 12.w),
            CustomText(
              text: subtitle,
              fontSize: 14.r,
              color: context.colors.textSecondary,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.w),
            CustomButton(
              label: 'Login / Sign up',
              onPressed: () {
                getIt<AppRouterNotifier>().setPendingRedirect(currentPath);
                Navigator.of(context).pop();
                context.push(RoutePaths.login);
              },
            ),
          ],
        ),
      ),
    );
  }
}
