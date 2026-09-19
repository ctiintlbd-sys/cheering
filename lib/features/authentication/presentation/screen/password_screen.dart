import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/helpers/toast_message_helper.dart';
import '../../../../core/router/auth_redirect.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/widgets/app_auth_title.dart';
import '../../../../core/widgets/widgets.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class PasswordScreen extends StatefulWidget {
  final String email;

  const PasswordScreen({super.key, required this.email});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<AuthBloc>().add(
      LoginRequested(email: widget.email, password: _passwordController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        switch ((state.status, state.action)) {
          case (AuthStatus.failure, AuthAction.login):
            ToastMessageHelper.show(
              state.errorMessage ??
                  'Login failed. Please check your credentials.',
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
          flexibleChild: AppAuthTitle(
            title: 'Hi, Welcome Back! 👋',
            subtitle: 'Enter your password for ${widget.email}',
          ),
        ),
        bodyList: [
          SizedBox(height: 16.h),
          Form(
            key: _formKey,
            child: CustomTextField.password(
              controller: _passwordController,
              labelText: 'Password',
              hintText: 'Enter your password',
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _onLogin(),
            ),
          ),
          SizedBox(height: 12.h),
          CustomText(
            onTap: () => context.push(
              AuthRedirect.withRedirectFromContext(
                context,
                RoutePaths.forgotPassword,
              ),
            ),
            text: 'Forgot Password?',
            color: context.colors.textSecondary,
          ),
          SizedBox(height: 24.h),
          BlocBuilder<AuthBloc, AuthState>(
            buildWhen: (prev, curr) =>
                prev.isLoginLoading != curr.isLoginLoading,
            builder: (context, state) {
              return CustomButton(
                label: 'Login with Password',
                isLoading: state.isLoginLoading,
                onPressed: _onLogin,
              );
            },
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
