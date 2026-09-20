import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/helpers/toast_message_helper.dart';
import '../../../../core/router/auth_redirect.dart';
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
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<AuthBloc>().add(
      ForgotPasswordRequested(email: _emailController.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        switch ((state.status, state.action)) {
          case (AuthStatus.failure, AuthAction.forgotPassword):
            ToastMessageHelper.show(
              state.errorMessage ?? 'Failed to send reset code.',
            );
          case (AuthStatus.success, AuthAction.forgotPassword):
            context.push(
              AuthRedirect.withRedirectFromContext(context, RoutePaths.otp),
              extra: {
                'email': _emailController.text.trim(),
                'isForgotPassword': true,
              },
            );
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
            title: 'Forgot Password? 🔐',
            subtitle:
                'Enter the email associated with your account and we\'ll send you a verification code.',
          ),
        ),
        bodyList: [
          SizedBox(height: 16.w),
          Form(
            key: _formKey,
            child: CustomTextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              labelText: 'Enter your email',
              hintText: 'example@email.com',
              validatorType: ValidatorType.email,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _onSubmit(),
            ),
          ),
          SizedBox(height: 24.w),
          BlocBuilder<AuthBloc, AuthState>(
            buildWhen: (prev, curr) =>
                prev.isForgotPasswordLoading != curr.isForgotPasswordLoading,
            builder: (context, state) {
              return CustomButton(
                label: 'Send Reset Code',
                isLoading: state.isForgotPasswordLoading,
                onPressed: _onSubmit,
              );
            },
          ),
          SizedBox(height: 24.w),
        ],
      ),
    );
  }
}
