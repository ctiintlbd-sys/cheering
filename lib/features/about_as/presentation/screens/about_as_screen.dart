import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/profile/presentation/screens/widgets/profile_menu_content.dart';
import 'package:cheering/features/profile/presentation/screens/widgets/profile_menu_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      sideContentPadding: 16.w,
      appBar: CustomSliverAppBar(
        backgroundColor: context.colors.background.withValues(alpha: 0.4),
        title: 'About Us',
      ),
      bodyList: [
        SizedBox(height: 100.w),
        Assets.images.appLogo.image(width: 61.w, height: 57.w),
        CustomText(
          textAlign: TextAlign.center,
          top: 16.w,
          text: 'CHEERING',
          fontSize: 20.r,
          fontWeight: FontWeight.w700,
          color: context.colors.textPrimary,
        ),
        CustomText(
          textAlign: TextAlign.center,
          top: 4.w,
          text: context.l10n.splashSubtitle,
          fontWeight: FontWeight.w500,
          fontSize: 14.r,
          color: context.colors.primary,
        ),
        CustomText(
          textAlign: TextAlign.center,
          top: 12.w,
          text: 'Version 1.0.0',
          fontWeight: FontWeight.w500,
          color: context.colors.textTertiary,
        ),

        SizedBox(height: 44.w),

        ProfileMenuContent(
          list: [
            ProfileMenuTile(title: 'Our Story', isLocked: true, onTap: () {}),
            ProfileMenuTile(
              title: 'Terms & Conditions',
              isLocked: true,
              onTap: () {},
            ),
            ProfileMenuTile(
              title: 'Privacy Policy',
              isLocked: true,
              onTap: () {},
              isBorder: false,
            ),
          ],
        ),

        SizedBox(height: 82.w),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              right: 12.w,
              textAlign: TextAlign.center,
              text: 'A Concern of ',
              fontWeight: FontWeight.w500,
              color: context.colors.textSecondary,
            ),

            Assets.images.fosol.image(width: 32.w, height: 32.w),
          ],
        ),
      ],
    );
  }
}
