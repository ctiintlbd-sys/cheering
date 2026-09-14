import 'package:cheering/core/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/helpers/toast_message_helper.dart';
import '../../../../core/l10n/locale_cubit.dart';
import '../../../../core/utils/assets/assets.gen.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../authentication/presentation/bloc/auth_bloc.dart';
import '../../../authentication/presentation/bloc/auth_event.dart';
import '../../../authentication/presentation/bloc/auth_state.dart';
import '../../../feedback/presentation/screens/widgets/profile_menu_tile.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_state.dart';
import 'widgets/profile_header_card.dart';
import 'widgets/profile_menu_content.dart';
import 'widgets/trailing_dropdown.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.failure &&
            state.action == AuthAction.logout) {
          ToastMessageHelper.show(
            state.errorMessage ??
                'Logout failed. You have been logged out locally.',
          );
        }
      },
      child: SliverScaffold(
        sideContentPadding: 16.w,
        appBar: const CustomSliverAppBar(title: 'Profile'),
        bodyList: [
          SizedBox(height: 16.h),

          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, profileState) {
              return ProfileHeaderCard(
                user : profileState.user
              );
            },
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
            onTap: () => _showLogoutDialog(context),
            isBorder: false,
            isTrailing: false,
          ),

          SizedBox(height: 124.h),
        ],
      ),
    );
  }


  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => CustomDialog(
        icon: Assets.icons.logoutPop.svg(),
        title: 'Are you sure want\nto logout?',
        description: 'You will need to login again to access your account',
        buttonLabel: 'Logout',
        buttonBgColor: dialogContext.colors.bgErrorPrimary.withValues(alpha: 0.10),
        buttonLabelColor: dialogContext.colors.bgErrorSecondary,
        onTapButton: () {
          Navigator.of(dialogContext).pop();
          context.read<AuthBloc>().add(const LogoutRequested());
        },
      ),
    );
  }

}
