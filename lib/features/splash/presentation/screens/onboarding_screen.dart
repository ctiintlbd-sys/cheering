import 'package:cheering/core/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/widgets.dart';
import '../../data/models/onboarding_items.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';
import '../bloc/onboarding_state.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage(int currentIndex) {
    if (currentIndex < onboardingList.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage(int currentIndex) {
    if (currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingBloc(),
      child: Scaffold(
        body: BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (context, state) {
            final isFirstPage = state.currentIndex == 0;
            final isLastPage = state.currentIndex == onboardingList.length - 1;
            return Stack(
              children: [
                // ── PageView ───────────────────────────────────────────────
                PageView.builder(
                  controller: _pageController,
                  itemCount: onboardingList.length,
                  onPageChanged: (index) {
                    context.read<OnboardingBloc>().add(OnboardingPageChanged(index));
                  },
                  itemBuilder: (context, index) {
                    final item = onboardingList[index];
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: kToolbarHeight + 32.h),
                        SvgPicture.asset(item.image),

                        const Spacer(),
                        CustomText(
                          left: 32.w,
                          right: 32.w,
                          text: item.title,
                          fontSize: 24.sp,
                          textAlign: TextAlign.center,
                        ),
                        CustomText(
                          top: 8.h,
                          left: 32.w,
                          right: 32.w,
                          text: item.subtitle,
                          fontWeight: FontWeight.w400,
                          textAlign: TextAlign.center,
                          color: context.colors.textSecondary,
                        ),
                        const Spacer(),
                        const Spacer(),
                      ],
                    );
                  },
                ),

                // ── Bottom controls ────────────────────────────────────────
                Positioned(
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
                              onTap: () => _previousPage(state.currentIndex),
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
                              onboardingList.length,
                              (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                margin: EdgeInsets.symmetric(horizontal: 6.w),
                                height: 8.r,
                                width: state.currentIndex == index ? 54.r : 8.r,
                                decoration: BoxDecoration(
                                  color: state.currentIndex == index
                                      ? context.colors.iconPrimary
                                      : context.colors.borderSecondary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),

                            const Spacer(),
                            // Right arrow
                            GestureDetector(
                              onTap: () => _nextPage(state.currentIndex),
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
                          label: "Get Started",
                          onPressed: () {
                            context.go(RoutePaths.ordersTab);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}