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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        switch ((state.status, state.action)) {
          case (AuthStatus.failure, AuthAction.enableBiometrics):
            ToastMessageHelper.show(
              state.errorMessage ?? 'Could not enable biometrics.',
            );
          case (AuthStatus.success, AuthAction.enableBiometrics):
            context.go(RoutePaths.foodTab);
          default:
            break;
        }
      },
      child: SliverScaffold(
        sideContentPadding: 24.w,
        appBar: CustomSliverAppBar(
          backgroundColor: context.colors.background.withValues(alpha: 0.4),
          expandedHeight: 180.h,
          flexibleChild: AppAuthTitle(
            title: 'Enable Touch ID / Face ID',
            subtitle:
                'Optional — enable for faster sign-in, or continue to the app.',
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
          BlocBuilder<AuthBloc, AuthState>(
            buildWhen: (prev, curr) =>
                prev.isEnableBiometricsLoading !=
                curr.isEnableBiometricsLoading,
            builder: (context, state) {
              final isLoading = state.isEnableBiometricsLoading;
              return Column(
                children: [
                  CustomButton(
                    label: 'Enable Biometrics',
                    isLoading: isLoading,
                    onPressed: isLoading
                        ? null
                        : () => context.read<AuthBloc>().add(
                            const EnableBiometricsRequested(),
                          ),
                  ),
                  SizedBox(height: 12.h),
                  CustomButton(
                    bordersColor: context.colors.borderPrimary,
                    backgroundColor: context.colors.background,
                    foregroundColor: context.colors.textPrimary,
                    label: 'Maybe Later',
                    onPressed: () => context.go(RoutePaths.foodTab),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
