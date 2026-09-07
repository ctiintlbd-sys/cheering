import 'package:flutter/widgets.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/l10n/l10n.dart';

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

List<OnboardingItem> getOnboardingList(BuildContext context) {
  final l10n = context.l10n;
  return [
    OnboardingItem(
      image: Assets.icons.onboardingOne.path,
      title: l10n.onboardingTitle1,
      subtitle: l10n.onboardingSubtitle1,
    ),
    OnboardingItem(
      image: Assets.icons.onboardingSecond.path,
      title: l10n.onboardingTitle2,
      subtitle: l10n.onboardingSubtitle2,
    ),
    OnboardingItem(
      image: Assets.icons.onboardingLast.path,
      title: l10n.onboardingTitle3,
      subtitle: l10n.onboardingSubtitle3,
    ),
  ];
}
