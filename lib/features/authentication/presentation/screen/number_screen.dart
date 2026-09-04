import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/core/utils/validators.dart';
import 'package:cheering/core/widgets/app_auth_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NumberScreen extends StatefulWidget {
  const NumberScreen({super.key});

  @override
  State<NumberScreen> createState() => _NumberScreenState();
}

class _NumberScreenState extends State<NumberScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _numberController = TextEditingController();

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  void _onContinueWithNumber() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
  }

  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      sideContentPadding: 24.w,
      appBar: CustomSliverAppBar(
        backgroundColor: context.colors.background.withValues(alpha: 0.4),
        expandedHeight: 144.h,
        flexibleChild: AppAuthTitle(
          title: 'Hi, Welcome Back! 👋',
          subtitle: 'Enter your phone number to sign in',
        ),
      ),
      bodyList: [
        SizedBox(height: 16.h),

        /// Number Input Field
        Form(
          key: _formKey,
          child: CustomTextField(
            controller: _numberController,
            keyboardType: TextInputType.phone,
            labelText: 'Enter your phone number',
            hintText: '123-456-7890',
            validatorType: ValidatorType.phone,
          ),
        ),
        SizedBox(height: 12.h),

        /// Login Button
        CustomButton(
          label: 'Continue with Phone',
          onPressed: _onContinueWithNumber,
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

        CustomButton(
          backgroundColor: context.colors.background,
          foregroundColor: context.colors.textPrimary,
          bordersColor: context.colors.borderSecondary,
          label: 'Continue with Email',
          onPressed: () {},
        ),
        SizedBox(height: 12.h),
        CustomButton(
          prefixIcon: Assets.icons.google.svg(),
          backgroundColor: context.colors.background,
          foregroundColor: context.colors.textPrimary,
          bordersColor: context.colors.borderSecondary,
          label: 'Continue with Google',
          onPressed: () {},
        ),
        SizedBox(height: 12.h),
        CustomButton(
          backgroundColor: context.colors.background,
          foregroundColor: context.colors.textPrimary,
          bordersColor: context.colors.borderSecondary,
          label: 'Continue with Facebook',
          onPressed: () {},
        ),
      ],
    );
  }
}
