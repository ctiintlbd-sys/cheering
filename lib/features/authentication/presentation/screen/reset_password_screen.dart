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

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String code;

  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.code,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<AuthBloc>().add(
          ResetPasswordRequested(
            email: widget.email,
            code: widget.code,
            newPassword: _passwordController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.failure &&
            state.action == AuthAction.resetPassword) {
          ToastMessageHelper.show(
            state.errorMessage ?? 'Failed to reset password. Please try again.',
          );
        } else if (state.status == AuthStatus.success &&
            state.action == AuthAction.resetPassword) {
          _buildShowDialog(context);
        }
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: SliverScaffold(
            appBar: CustomSliverAppBar(
              backgroundColor: context.colors.background.withValues(alpha: 0.4),
              expandedHeight: 180.h,
              flexibleChild: AppAuthTitle(
                title: 'Create New Password 🔑',
                subtitle:
                    'Your new password must be different from the previously used password',
              ),
            ),
            bodyList: [
              SizedBox(height: 16.h),

              /// New Password
              CustomTextField.password(
                controller: _passwordController,
                labelText: 'Create New Password',
                hintText: 'Type your new password',
                validatorType: ValidatorType.password,
              ).horizontal(24),

              SizedBox(height: 12.h),

              /// Confirm Password
              CustomTextField.password(
                controller: _confirmPasswordController,
                labelText: 'Re-enter Password',
                hintText: 'Type your new password again',
                validator: FieldValidator.of(
                  ValidatorType.confirmPassword,
                  matchController: _passwordController,
                ),
              ).horizontal(24),

              SizedBox(height: 24.h),

              /// Confirm Button
              CustomButton(
                label: 'Reset Password',
                isLoading: state.isResetPasswordLoading,
                onPressed: _onSubmit,
              ).horizontal(24),

              SizedBox(height: 24.h),
            ],
          ),
        );
      },
    );
  }

  Future<dynamic> _buildShowDialog(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => CustomDialog(
        icon: Assets.icons.orderCompleted.svg(height: 80.r, width: 80.r),
        title: 'Password Changed!',
        description:
            'Your password has been updated successfully. Please log in with your new password to continue.',
        buttonLabel: 'Login Now',
        onTapButton: () {
          context.go(RoutePaths.login);
        },
      ),
    );
  }
}
