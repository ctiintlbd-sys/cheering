import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/helpers/toast_message_helper.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_auth_title.dart';
import '../../../../core/widgets/widgets.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final email = _emailController.text.trim();
    context.read<AuthBloc>().add(ForgotPasswordRequested(email: email));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.failure &&
            state.action == AuthAction.forgotPassword) {
          ToastMessageHelper.show(
            state.errorMessage ?? 'Failed to send reset code.',
          );
        } else if (state.status == AuthStatus.success &&
            state.action == AuthAction.forgotPassword) {
          ToastMessageHelper.show(
            state.successMessage ?? 'Reset code sent to your email.',
          );
          context.push(
            RoutePaths.otp,
            extra: {
              'email': _emailController.text.trim(),
              'isForgotPassword': true,
            },
          );
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
                title: 'Forgot Password? 🔐',
                subtitle:
                    'Enter the email address associated with your account and we\'ll send you a verification code',
              ),
            ),
            bodyList: [
              SizedBox(height: 16.h),

              /// Email Input Field
              CustomTextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                labelText: 'Enter your email',
                hintText: 'example@email.com',
                validatorType: ValidatorType.email,
              ).horizontal(24),

              SizedBox(height: 24.h),

              /// Send Code Button
              CustomButton(
                label: 'Send Reset Code',
                isLoading: state.isForgotPasswordLoading,
                onPressed: _onSubmit,
              ).horizontal(24),

              SizedBox(height: 24.h),
            ],
          ),
        );
      },
    );
  }
}
