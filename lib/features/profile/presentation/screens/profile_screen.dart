import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/feedback/presentation/screens/widgets/profile_menu_tile.dart';
import 'package:cheering/features/profile/presentation/screens/widgets/profile_menu_content.dart';
import 'package:cheering/features/profile/presentation/screens/widgets/trailing_dropdown.dart';
import 'package:cheering/core/theme/theme_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      sideContentPadding: 16.w,
      appBar: const CustomSliverAppBar(title: 'Profile'),
      bodyList: [
        SizedBox(height: 16.h),

        CustomContainer(
          paddingVertical: 8.h,
          paddingHorizontal: 12.w,
          radiusAll: 8.r,
          color: context.colors.bgSecondary,
          child: Row(
            children: [
              CustomNetworkImage(
                boxShape: BoxShape.circle,
                height: 64.r,
                width: 64.r,
                imageUrl: '',
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      text: 'Jenia Rahman',
                    ),
                    CustomText(
                      top: 4.h,
                      color: context.colors.textTertiary,
                      text: 'Jenia Rahman',
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.arrow_forward_ios_rounded,
                color: context.colors.iconTertiary,
              ),
            ],
          ),
        ),

        SizedBox(height: 20.h),

        ProfileMenuContent(
          title: 'My Account',
          list: [
            ProfileMenuTile(
              title: 'Address',
              icon: Assets.icons.profileAddress.svg(),
              onTap: () {},
            ),
            ProfileMenuTile(
              title: 'Coupons and Offer',
              icon: Assets.icons.profileOffer.svg(),
              onTap: () {},
            ),
            ProfileMenuTile(
              title: 'Payment Method',
              icon: Assets.icons.profilePayment.svg(),
              onTap: () {},
              isBorder: false,
            ),
          ],
        ),

        SizedBox(height: 20.h),
        ProfileMenuContent(
          title: 'Preferences',
          list: [
            ProfileMenuTile(
              title: 'Notification',
              icon: Assets.icons.profileNotification.svg(),
              onTap: () {},
            ),
            ProfileMenuTile(
              title: 'Language',
              icon: Assets.icons.profileLanguage.svg(),
              onTap: () {},
              trailingWidget: TrailingDropdown(
                items: const ['English', 'Bangla'],
                initialValue: 'English',
                onChanged: (value) {},
              ),
            ),
            BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, themeMode) {
                String currentMode = 'System';
                if (themeMode == ThemeMode.light) currentMode = 'Light';
                if (themeMode == ThemeMode.dark) currentMode = 'Dark';
                
                return ProfileMenuTile(
                  title: 'Appearance',
                  icon: Assets.icons.profileAppearance.svg(),
                  onTap: () {},
                  isBorder: false,
                  trailingWidget: TrailingDropdown(
                    items: const ['System', 'Light', 'Dark'],
                    initialValue: currentMode,
                    onChanged: (value) {
                      ThemeMode newMode = ThemeMode.system;
                      if (value == 'Light') newMode = ThemeMode.light;
                      if (value == 'Dark') newMode = ThemeMode.dark;
                      context.read<ThemeCubit>().updateTheme(newMode);
                    },
                  ),
                );
              },
            ),
          ],
        ),

        SizedBox(height: 20.h),
        ProfileMenuContent(
          title: 'Account & Security',
          list: [
            ProfileMenuTile(
              title: 'Account Settings',
              icon: Assets.icons.profile.svg(),
              onTap: () {},
            ),
            ProfileMenuTile(
              title: 'Security',
              icon: Assets.icons.profileSecurity.svg(),
              onTap: () {},
              isBorder: false,
            ),
          ],
        ),

        SizedBox(height: 20.h),
        ProfileMenuContent(
          title: 'Support',
          list: [
            ProfileMenuTile(
              title: 'Help Center',
              icon: Assets.icons.profileHelp.svg(),
              onTap: () {},
            ),
            ProfileMenuTile(
              title: 'About us',
              icon: Assets.icons.profileAbout.svg(),
              onTap: () {},
              isBorder: false,
            ),
          ],
        ),

        SizedBox(height: 20.h),
        ProfileMenuTile(
          bgColor: context.colors.bgErrorPrimary.withValues(alpha: 0.1),
          title: 'Logout',
          textColor: context.colors.bgErrorSecondary,
          icon: Assets.icons.profileLogout.svg(),
          onTap: () {},
          isBorder: false,
          isTrailing: false,
        ),

        SizedBox(height: 124.h),
      ],
    );
  }
}
