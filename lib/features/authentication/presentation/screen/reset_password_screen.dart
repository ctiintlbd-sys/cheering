import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/utils/validators.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/core/widgets/app_auth_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';


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

  }

  @override
  Widget build(BuildContext context) {
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
          SizedBox(height: 16.h).asSliver,

          /// New Password
          CustomTextField.password(
            controller: _passwordController,
            labelText: 'Create New Password',
            hintText: 'Type your new password',
            validatorType: ValidatorType.password,
          ).asSliverWithPadding(horizontal: 24.w),

          SizedBox(height: 12.h).asSliver,

          /// Confirm Password
          CustomTextField.password(
            controller: _confirmPasswordController,
            labelText: 'Re-enter Password',
            hintText: 'Type your new password again',
            validator: FieldValidator.of(
              ValidatorType.confirmPassword,
              matchController: _passwordController,
            ),
          ).asSliverWithPadding(horizontal: 24.w),

          SizedBox(height: 24.h).asSliver,

          /// Confirm Button
        CustomButton(
          label: 'Reset Password',
          onPressed:  _onSubmit,

          ).asSliverWithPadding(horizontal: 24.w),

          SizedBox(height: 24.h).asSliver,
        ],
      ),
    );
  }

  Future<dynamic> _buildShowDialog(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => CustomDialog(
        icon: Assets.icons.orderCompleted.svg(height: 80.r, width: 80.r),
        title: 'Password Changed!',
        description: 'Your password has been updated successfully. Please log in with your new password to continue.',
        buttonLabel: 'Login Now',
        onTapButton: () {
          context.go(RoutePaths.login);
        },
      ),
    );
  }
}
