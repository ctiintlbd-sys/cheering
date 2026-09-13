import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/feedback/presentation/screens/widgets/profile_menu_tile.dart';
import 'package:cheering/features/profile/presentation/screens/widgets/profile_header_card.dart';
import 'package:cheering/features/profile/presentation/screens/widgets/profile_menu_content.dart';
import 'package:cheering/features/profile/presentation/screens/widgets/trailing_dropdown.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cheering/core/l10n/locale_cubit.dart';
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

        ProfileHeaderCard(
          name: 'Jenia Rahman',
          subtitle: 'Jenia Rahman',
          imageUrl: '',
          onTap: () {},
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
            BlocBuilder<LocaleCubit, Locale>(
              builder: (context, locale) {
                final localeCubit = context.read<LocaleCubit>();
                return ProfileMenuTile(
                  title: 'Language',
                  icon: Assets.icons.profileLanguage.svg(),
                  onTap: () {},
                  trailingWidget: TrailingDropdown(
                    items: const ['English', 'Bangla'],
                    initialValue: localeCubit.currentLanguageName,
                    onChanged: (value) {
                      localeCubit.updateLocaleFromName(value.toString());
                    },
                  ),
                );
              }
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
