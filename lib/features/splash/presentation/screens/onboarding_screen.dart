import 'package:cheering/core/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/assets/assets.gen.dart';
import '../../../../core/widgets/widgets.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight),
          Assets.icons.appLogo.svg(width: 171.w, height: 52.h),
          SizedBox(height: 24.h),
          Expanded(
            child: Assets.images.onboarding.image(
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ),
          CustomText(
            left: 16.w,
            right: 16.w,
            text: 'Grow your business with Cheering Shop',
            fontSize: 24.sp,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w600,
          ),
          CustomText(
            top: 16.h,
            left: 16.w,
            right: 16.w,
            textAlign: TextAlign.center,
            text:
            'Reach thousands in food, grocery, and pharmacy delivery '
                'with easy order management and payouts.',
            color: context.colors.textTertiary,
          ),
          SizedBox(height: 42.h),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomButton(
              onPressed: () {
                context.push(RoutePaths.businessInformation);
              },
              label: 'Become a partner',
            ),
            SizedBox(height: 14.h),
            CustomButton(
              backgroundColor: context.colors.background,
              borderColor: context.colors.borderPrimary,
              foregroundColor: context.colors.textPrimary,
              onPressed: () {
                context.go(RoutePaths.login);
              }, // TODO: navigate to login
              label: 'Login',
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 8.h),
          ],
        ),
      ),
    );
  }
}