import 'package:cheering/core/utils/validators.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/core/widgets/app_auth_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
            title: 'Forgot Password? 🔐',
            subtitle:
            'Enter the email address associated with your account and we\'ll send you a verification code',
          ),
        ),
        bodyList: [
          SizedBox(height: 16.h).asSliver,

          /// Email Input Field
          CustomTextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            labelText: 'Enter your email',
            hintText: 'example@email.com',
            validatorType: ValidatorType.email,
          ).asSliverWithPadding(horizontal: 24.w),

          SizedBox(height: 24.h).asSliver,

          /// Send Code Button
          CustomButton(
            label: 'Send Reset Code',
            onPressed:  _onSubmit,
          ).asSliverWithPadding(horizontal: 24.w),

          SizedBox(height: 24.h).asSliver,
        ],
      ),
    );
  }
}
