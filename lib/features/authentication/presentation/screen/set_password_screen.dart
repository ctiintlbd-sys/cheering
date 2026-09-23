import "package:cheering/core/router/route_args.dart";

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/helpers/toast_message_helper.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/utils/assets/assets.gen.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_auth_title.dart';
import '../../../../core/widgets/widgets.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class SetPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;
  final bool isForgotPassword;

  const SetPasswordScreen({
    super.key,
    required this.email,
    required this.otp,
    this.isForgotPassword = false,
  });

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String get _password => _passwordController.text;

  void _onSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (widget.isForgotPassword) {
      context.read<AuthBloc>().add(
        ResetPasswordRequested(
          email: widget.email,
          code: widget.otp,
          newPassword: _password,
        ),
      );
      return;
    }
    context.push(
      RoutePaths.about,
      extra: AboutScreenArgs(email: widget.email, otp: widget.otp, password: _password),
    );
  }

  void _showResetSuccessDialog() {
    showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (dialogContext) => CustomDialog(
        icon: Assets.icons.orderCompleted.svg(height: 80.r, width: 80.r),
        title: 'Password Changed!',
        description:
            'Your password has been updated successfully. Please log in with your new password to continue.',
        buttonLabel: 'Login Now',
        onTapButton: () => dialogContext.go(RoutePaths.login),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (prev, curr) =>
          widget.isForgotPassword &&
          curr.action == AuthAction.resetPassword &&
          prev.status != curr.status,
      listener: (context, state) {
        switch (state.status) {
          case AuthStatus.failure:
            ToastMessageHelper.show(
              state.errorMessage ??
                  'Failed to reset password. Please try again.',
            );
          case AuthStatus.success:
            _showResetSuccessDialog();
          default:
            break;
        }
      },
      child: SliverScaffold(
        sideContentPadding: 24.w,
        appBar: CustomSliverAppBar(
          backgroundColor: context.colors.background.withValues(alpha: 0.4),
          expandedHeight: 144.w,
          flexibleChild: AppAuthTitle(
            title: 'Set Password',
            subtitle: 'Enter your desired password in both fields.',
          ),
        ),
        bodyList: [
          SizedBox(height: 16.w),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextField.password(
                  controller: _passwordController,
                  labelText: 'New Password',
                  hintText: '••••••••',
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 24.w),
                CustomTextField.password(
                  controller: _confirmPasswordController,
                  labelText: 'Re-enter Password',
                  hintText: '••••••••',
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _onSubmit(),
                  validator: FieldValidator.of(
                    ValidatorType.confirmPassword,
                    matchController: _passwordController,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.w),
          if (widget.isForgotPassword)
            BlocBuilder<AuthBloc, AuthState>(
              buildWhen: (prev, curr) =>
                  prev.isResetPasswordLoading != curr.isResetPasswordLoading,
              builder: (context, state) {
                return CustomButton(
                  label: 'Reset Password',
                  isLoading: state.isResetPasswordLoading,
                  onPressed: _onSubmit,
                );
              },
            )
          else
            CustomButton(label: 'Confirm', onPressed: _onSubmit),
          SizedBox(height: 24.w),
        ],
      ),
    );
  }
}
