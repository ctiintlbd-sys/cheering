import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/helpers/toast_message_helper.dart';
import '../../data/services/biometric_service.dart';
import '../utils/biometric_ui_kind_assets.dart';
import '../../../../core/router/auth_redirect.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/utils/assets/assets.gen.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_auth_title.dart';
import '../../../../core/widgets/widgets.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'widgets/touch_face_id_sheet.dart';

class EmailScreen extends StatefulWidget {
  const EmailScreen({super.key});

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onContinueWithEmail() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final email = _emailController.text.trim();
    final isSignUp = context.read<AuthBloc>().state.isSignUp;

    if (isSignUp) {
      context.read<AuthBloc>().add(SendOtpRequested(email: email));
    } else {
      context.push(
        AuthRedirect.withRedirectFromContext(context, RoutePaths.password),
        extra: email,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        switch ((state.status, state.action)) {
          case (
            AuthStatus.failure,
            AuthAction.sendOtp || AuthAction.googleLogin,
          ):
            ToastMessageHelper.show(
              state.errorMessage ?? 'An unexpected error occurred.',
            );
          case (AuthStatus.success, AuthAction.sendOtp):
            context.push(
              AuthRedirect.withRedirectFromContext(context, RoutePaths.otp),
              extra: _emailController.text.trim(),
            );
          default:
            break;
        }
      },
      child: SliverScaffold(
        sideContentPadding: 24.w,
        appBar: CustomSliverAppBar(
          backgroundColor: context.colors.background.withValues(alpha: 0.4),
          expandedHeight: 144.h,
          flexibleChild: BlocSelector<AuthBloc, AuthState, bool>(
            selector: (state) => state.isSignUp,
            builder: (context, isSignUp) {
              return AppAuthTitle(
                title: 'Hi, Welcome Back! 👋',
                subtitle: isSignUp
                    ? 'Enter your email to receive a verification code'
                    : 'Enter your email and password to sign in',
              );
            },
          ),
        ),
        bodyList: [
          SizedBox(height: 16.h),

          /// Email Input Field (stateless from bloc, zero rebuilds on mode toggle)
          Form(
            key: _formKey,
            child: CustomTextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              labelText: 'Enter your email',
              hintText: 'example@email.com',
              validatorType: ValidatorType.email,
            ),
          ),
          SizedBox(height: 12.h),

          /// Primary Action Button
          BlocBuilder<AuthBloc, AuthState>(
            buildWhen: (prev, curr) =>
                prev.isSignUp != curr.isSignUp ||
                prev.isSendOtpLoading != curr.isSendOtpLoading,
            builder: (context, state) {
              return CustomButton(
                label: state.isSignUp
                    ? 'Send Verification Code'
                    : 'Continue with Email',
                isLoading: state.isSignUp && state.isSendOtpLoading,
                onPressed: _onContinueWithEmail,
              );
            },
          ),

          /// Biometric login (sign-in only, after server enrollment)
          BlocSelector<AuthBloc, AuthState, bool>(
            selector: (state) => state.isSignUp,
            builder: (context, isSignUp) {
              if (isSignUp) return const SizedBox.shrink();
              final biometricService = getIt<BiometricService>();
              if (!biometricService.canUseBiometricLogin) {
                return const SizedBox.shrink();
              }
              final biometricUi = biometricService.biometricUiKind;
              return Padding(
                padding: EdgeInsets.only(top: 12.h),
                child: CustomButton(
                  prefixIcon: biometricUi.icon.svg(),
                  backgroundColor: context.colors.background,
                  foregroundColor: context.colors.textPrimary,
                  bordersColor: context.colors.borderSecondary,
                  label: biometricUi.continueWithLabel,
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const TouchFaceIdSheet(),
                    );
                  },
                ),
              );
            },
          ),

          SizedBox(height: 34.h),
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: context.colors.borderSecondary,
                  thickness: 1.0,
                ),
              ),
              CustomText(text: '   Or   ', color: context.colors.textTertiary),
              Expanded(
                child: Divider(
                  color: context.colors.borderSecondary,
                  thickness: 1.0,
                ),
              ),
            ],
          ),

          SizedBox(height: 34.h),

          /// Google Sign-In Button
          BlocSelector<AuthBloc, AuthState, bool>(
            selector: (state) => state.isGoogleLoading,
            builder: (context, isGoogleLoading) {
              return CustomButton(
                prefixIcon: Assets.icons.google.svg(),
                backgroundColor: context.colors.background,
                foregroundColor: context.colors.textPrimary,
                bordersColor: context.colors.borderSecondary,
                label: 'Continue with Google',
                isLoading: isGoogleLoading,
                onPressed: () {
                  context.read<AuthBloc>().add(const GoogleLoginRequested());
                },
              );
            },
          ),

          SizedBox(height: 28.h),

          /// Switch between Sign In and Sign Up via AuthBloc
          Center(
            child: BlocSelector<AuthBloc, AuthState, bool>(
              selector: (state) => state.isSignUp,
              builder: (context, isSignUp) {
                return GestureDetector(
                  onTap: () {
                    context.read<AuthBloc>().add(const ToggleAuthMode());
                  },
                  child: RichText(
                    text: TextSpan(
                      text: isSignUp
                          ? 'Already have an account? '
                          : "Don't have an account? ",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: context.colors.textSecondary,
                      ),
                      children: [
                        TextSpan(
                          text: isSignUp ? 'Sign In' : 'Sign Up',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: context.colors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
