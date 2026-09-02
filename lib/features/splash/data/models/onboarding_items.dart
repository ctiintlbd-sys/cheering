import 'package:cheering/core/utils/assets/assets.gen.dart';

class OnboardingItem {
  final String image;
  final String title;
  final String subtitle;

  OnboardingItem({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}

final onboardingList = [
  OnboardingItem(
    image: Assets.icons.onboardingOne.path,
    title: "Order Food & Book Rides",
    subtitle:
    "Enjoy fast food delivery, instant ride booking, and trusted everyday services with just a few simple taps.",
  ),
  OnboardingItem(
    image: Assets.icons.onboardingSecond.path,
    title: "Pay & Top Up Instantly",
    subtitle:
    "Add money, make secure payments, and manage your wallet anytime with a smooth and simple experience.",
  ),
  OnboardingItem(
    image: Assets.icons.onboardingLast.path,
    title: "Shop & Save Every Day",
    subtitle:
    "Buy groceries, order medicines, explore great deals, and enjoy everything you need in one convenient app.",
  ),
];