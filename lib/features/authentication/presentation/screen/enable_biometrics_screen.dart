import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/helpers/toast_message_helper.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/utils/assets/assets.gen.dart';
import '../../../../core/widgets/app_auth_title.dart';
import '../../../../core/widgets/widgets.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class EnableBiometricsScreen extends StatelessWidget {
  const EnableBiometricsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (prev, curr) =>
          curr.action == AuthAction.enableBiometrics ||
          curr.action == AuthAction.skipBiometrics,
      listener: (context, state) {
        if (state.status == AuthStatus.failure &&
            state.action == AuthAction.enableBiometrics) {
          ToastMessageHelper.show(
            state.errorMessage ?? 'Could not enable biometrics.',
          );
          return;
        }

        if (state.status == AuthStatus.success) {
          if (state.successMessage != null) {
            ToastMessageHelper.show(state.successMessage!);
          }
          context.go(RoutePaths.foodTab);
        }
      },
      builder: (context, state) {
        final isLoading = state.isEnableBiometricsLoading ||
            (state.isLoading && state.action == AuthAction.skipBiometrics);

        return SliverScaffold(
          sideContentPadding: 24.w,
          appBar: CustomSliverAppBar(
            backgroundColor: context.colors.background.withValues(alpha: 0.4),
            expandedHeight: 180.h,
            flexibleChild: AppAuthTitle(
              title: 'Enable Touch ID / Face ID',
              subtitle:
                  'Enable biometric login for faster, more secure access to your account.',
            ),
          ),
          bodyList: [
            SizedBox(height: 16.h),
            CustomContainer(
              height: 120.r,
              width: 120.r,
              shape: BoxShape.circle,
              child: Assets.icons.face.svg(),
            ),
            SizedBox(height: 24.h),
            CustomButton(
              label: 'Enable Biometrics',
              isLoading: state.isEnableBiometricsLoading,
              onPressed: isLoading
                  ? null
                  : () => context
                      .read<AuthBloc>()
                      .add(const EnableBiometricsRequested()),
            ),
            SizedBox(height: 12.h),
            CustomButton(
              bordersColor: context.colors.borderPrimary,
              backgroundColor: context.colors.background,
              foregroundColor: context.colors.textPrimary,
              label: 'Maybe Later',
              onPressed: isLoading
                  ? null
                  : () => context
                      .read<AuthBloc>()
                      .add(const SkipBiometricsRequested()),
            ),
          ],
        );
      },
    );
  }
}
