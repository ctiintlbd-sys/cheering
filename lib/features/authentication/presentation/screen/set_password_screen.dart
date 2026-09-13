import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/utils/validators.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/core/widgets/app_auth_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SetPasswordScreen extends StatefulWidget {
  final String email, otp;

  const SetPasswordScreen({super.key, required this.email, required this.otp});

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

  void _onSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.push(RoutePaths.about, extra:  {
      'email': widget.email,
      'otp': widget.otp,
      'password': _confirmPasswordController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SliverScaffold(
        sideContentPadding: 24.w,
        appBar: CustomSliverAppBar(
          backgroundColor: context.colors.background.withValues(alpha: 0.4),
          expandedHeight: 180.h,
          flexibleChild: AppAuthTitle(
            title: 'Set Password',
            subtitle:
                'To set a password, please enter your desired password in both fields.',
          ),
        ),
        bodyList: [
          SizedBox(height: 16.h),

          /// Password Input Field
          CustomTextField.password(
            controller: _passwordController,
            labelText: 'New Password',
            hintText: '••••••••',
          ),

          SizedBox(height: 24.h),

          /// Confirm Password Input Field
          CustomTextField.password(
            controller: _confirmPasswordController,
            labelText: 'Re-enter Password',
            hintText: '••••••••',
            validator: FieldValidator.of(
              ValidatorType.confirmPassword,
              matchController: _passwordController,
            ),
          ),

          SizedBox(height: 24.h),

          /// Set Password Button
          CustomButton(label: 'Confirm', onPressed: _onSubmit),

          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
