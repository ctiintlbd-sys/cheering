import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/helpers/toast_message_helper.dart';
import '../../../../core/l10n/locale_cubit.dart';
import '../../../../core/utils/assets/assets.gen.dart';
import '../../../../core/widgets/widgets.dart';
import 'widgets/profile_empty_widget.dart';
import '../../../authentication/presentation/bloc/auth_bloc.dart';
import '../../../authentication/presentation/bloc/auth_event.dart';
import '../../../authentication/presentation/bloc/auth_state.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_state.dart';
import 'widgets/profile_header_card.dart';
import 'widgets/profile_header_shimmer.dart';
import 'widgets/profile_menu_tile.dart';
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
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, profileState) {
          final isAuthenticated = profileState.hasUser;
          return SliverScaffold(
            sideContentPadding: 16.w,
            appBar: CustomSliverAppBar(
              expandedHeight: isAuthenticated ? 0 : 414.h,
              title: 'Profile',
              flexibleChild: isAuthenticated
                  ? null
                  : const ProfileEmptyWidget(),
            ),
            bodyList: [
              // ── Profile Header (only when authenticated) ──
              if (isAuthenticated) ...[
                SizedBox(height: 16.h),
                profileState.isLoadProfileLoading
                    ? const ProfileHeaderShimmer()
                    : ProfileHeaderCard(user: profileState.user),
              ],

              SizedBox(height: 20.h),

              // ── My Account (only when authenticated) ──
              if (isAuthenticated) ...[
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
              ],

              // ── Preferences (always visible) ──
              ProfileMenuContent(
                title: 'Preferences',
                list: [
                  if (isAuthenticated)
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
                        isBorder: false,
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

              // ── Support (always visible) ──
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

              // ── Logout (only when authenticated) ──
              if (isAuthenticated) ...[
                SizedBox(height: 20.h),
                ProfileMenuTile(
                  bgColor:
                      context.colors.bgErrorPrimary.withValues(alpha: 0.1),
                  title: 'Logout',
                  textColor: context.colors.bgErrorSecondary,
                  icon: Assets.icons.profileLogout.svg(),
                  onTap: () => _showLogoutDialog(context),
                  isBorder: false,
                  isTrailing: false,
                ),
              ],

              SizedBox(height: 124.h),
            ],
          );
        },
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
        buttonBgColor: dialogContext.colors.bgErrorPrimary.withValues(
          alpha: 0.10,
        ),
        buttonLabelColor: dialogContext.colors.bgErrorSecondary,
        onTapButton: () {
          Navigator.of(dialogContext).pop();
          context.read<AuthBloc>().add(const LogoutRequested());
        },
      ),
    );
  }
}
