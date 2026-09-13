import 'package:cheering/core/di/service_locator.dart';
import 'package:cheering/core/router/app_router_notifier.dart';
import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/storage/onboarding_storage.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/splash/data/models/onboarding_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class OnboardingBottomControls extends StatelessWidget {
  final int currentIndex;
  final VoidCallback onPreviousPage;
  final VoidCallback onNextPage;

  const OnboardingBottomControls({
    super.key,
    required this.currentIndex,
    required this.onPreviousPage,
    required this.onNextPage,
  });

  @override
  Widget build(BuildContext context) {
    final isFirstPage = currentIndex == 0;
    final isLastPage = currentIndex == getOnboardingList(context).length - 1;
    return Positioned(
      left: 16.w,
      right: 16.w,
      bottom: 16.h,
      child: SafeArea(
        child: Column(
          children: [
            // Dots indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Left arrow
                GestureDetector(
                  onTap: onPreviousPage,
                  child: CustomContainer(
                    paddingAll: 8.w,
                    shape: BoxShape.circle,
                    color: context.colors.bgSecondary,
                    child: Icon(
                      Icons.chevron_left_rounded,
                      size: 28.r,
                      color: isFirstPage
                          ? context.colors.iconPrimary.withValues(alpha: 0.3)
                          : context.colors.iconPrimary,
                    ),
                  ),
                ),

                const Spacer(),

                // Dots
                ...List.generate(
                  getOnboardingList(context).length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    margin: EdgeInsets.symmetric(horizontal: 6.w),
                    height: 8.r,
                    width: currentIndex == index ? 54.r : 8.r,
                    decoration: BoxDecoration(
                      color: currentIndex == index
                          ? context.colors.iconPrimary
                          : context.colors.borderSecondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const Spacer(),
                // Right arrow
                GestureDetector(
                  onTap: onNextPage,
                  child: CustomContainer(
                    paddingAll: 8.w,
                    shape: BoxShape.circle,
                    color: context.colors.bgSecondary,
                    child: Icon(
                      Icons.chevron_right_rounded,
                      size: 28.r,
                      color: isLastPage
                          ? context.colors.iconPrimary.withValues(alpha: 0.3)
                          : context.colors.iconPrimary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.h),

            CustomButton(
              label: context.l10n.getStartedButton,
              onPressed: () async {
                await OnboardingStorage.setOnboardingCompleted(true);
                getIt<AppRouterNotifier>().completeOnboarding();
                if (context.mounted) {
                  context.go(RoutePaths.login);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
