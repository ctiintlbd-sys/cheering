import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/core/utils/validators.dart';
import 'package:cheering/core/widgets/app_auth_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_paths.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailOrNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailOrNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SliverScaffold(
        appBar: CustomSliverAppBar(
          backgroundColor: context.colors.background.withValues(alpha: 0.4),
          expandedHeight: 134.h,
          flexibleChild: AppAuthTitle(
            title: 'Hi, Welcome Back! 👋',
            subtitle: 'Enter your email and password to sign in',
          ),
        ),
        bodyList: [
          SizedBox(height: 16.h),

          /// Email Input Field
          CustomTextField(
            controller: _emailOrNumberController,
            keyboardType: TextInputType.emailAddress,
            labelText: 'Enter your email',
            hintText: 'example@email.com',
            validatorType: ValidatorType.email,
          ).horizontal(24),

          SizedBox(height: 12.h),

          /// Password Input Field
          CustomTextField.password(
            controller: _passwordController,
            labelText: 'Password',
            hintText: 'Enter your password',
          ).horizontal(24),

          SizedBox(height: 12.h),

          /// Forgot Password
          CustomText(
            onTap: () => context.push(RoutePaths.forgotPassword),
            text: 'Forgot Password?',
            color: context.colors.textSecondary,
          ).horizontal(24),

          SizedBox(height: 24.h),

          /// Login Button
          CustomButton(
            label: 'Sign In',
            onPressed:  _onLogin,
          ).horizontal(24),

          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
