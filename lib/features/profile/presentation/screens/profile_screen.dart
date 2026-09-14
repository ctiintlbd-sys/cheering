import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/toast_message_helper.dart';
import '../../../../core/l10n/locale_cubit.dart';
import '../../../../core/utils/assets/assets.gen.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../authentication/presentation/bloc/auth_bloc.dart';
import '../../../authentication/presentation/bloc/auth_event.dart';
import '../../../authentication/presentation/bloc/auth_state.dart';
import '../../../feedback/presentation/screens/widgets/profile_menu_tile.dart';
import 'widgets/profile_header_card.dart';
import 'widgets/profile_menu_content.dart';
import 'widgets/trailing_dropdown.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: dialogContext.colors.background,
        insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomContainer(
                height: 64.r,
                width: 64.r,
                shape: BoxShape.circle,
                color:
                    dialogContext.colors.bgErrorPrimary.withValues(alpha: 0.1),
                child: Center(
                  child: Assets.icons.profileLogout.svg(
                    width: 32.r,
                    height: 32.r,
                    color: dialogContext.colors.bgErrorSecondary,
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              CustomText(
                text: 'Log Out',
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.center,
                color: dialogContext.colors.textPrimary,
              ),
              SizedBox(height: 8.h),
              CustomText(
                text: 'Are you sure you want to log out of your account?',
                fontSize: 14.sp,
                textAlign: TextAlign.center,
                color: dialogContext.colors.textSecondary,
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      label: 'Cancel',
                      backgroundColor: dialogContext.colors.background,
                      foregroundColor: dialogContext.colors.textPrimary,
                      bordersColor: dialogContext.colors.borderSecondary,
                      onPressed: () => Navigator.of(dialogContext).pop(),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: CustomButton(
                      label: 'Log Out',
                      backgroundColor: dialogContext.colors.bgErrorSecondary,
                      foregroundColor: Colors.white,
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        context.read<AuthBloc>().add(const LogoutRequested());
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

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
}
