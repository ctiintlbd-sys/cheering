import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/splash/data/models/onboarding_items.dart';
import 'package:cheering/features/splash/presentation/bloc/onboarding_bloc.dart';
import 'package:cheering/features/splash/presentation/bloc/onboarding_event.dart';
import 'package:cheering/features/splash/presentation/bloc/onboarding_state.dart';
import 'package:cheering/features/splash/presentation/screens/widgets/onboarding_bottom_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    if (currentIndex < getOnboardingList(context).length - 1) {
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
    return Scaffold(
      body: Stack(
        children: [
          // ── PageView ───────────────────────────────────────────────
          PageView.builder(
            controller: _pageController,
            itemCount: getOnboardingList(context).length,
            onPageChanged: (index) {
              context.read<OnboardingBloc>().add(OnboardingPageChanged(index));
            },
            itemBuilder: (context, index) {
              final item = getOnboardingList(context)[index];
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
          BlocBuilder<OnboardingBloc, OnboardingState>(
            builder: (context, state) {
              return OnboardingBottomControls(
                currentIndex: state.currentIndex,
                onPreviousPage: () => _previousPage(state.currentIndex),
                onNextPage: () => _nextPage(state.currentIndex),
              );
            },
          ),
        ],
      ),
    );
  }
}
