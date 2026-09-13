import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/helpers/toast_message_helper.dart';
import '../../../../core/router/app_router_notifier.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/utils/assets/assets.gen.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_auth_title.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/usecases/login_with_google_usecase.dart';
import '../../domain/usecases/send_otp_usecase.dart';
import 'widgets/touch_face_id_sheet.dart';

class EmailScreen extends StatefulWidget {
  const EmailScreen({super.key});

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  bool _isSignUp = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _onContinueWithEmail() async {
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
          subtitle: _isSignUp
              ? 'Enter your email to receive a verification code'
              : 'Enter your email and password to sign in',
        ),
      ),
      bodyList: [
        SizedBox(height: 16.h),

        /// Email Input Field
        Form(
          key: _formKey,
          child: CustomTextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            labelText: 'Enter your email',
            hintText: 'example@email.com',
            validatorType: ValidatorType.email,
          ),
        ),
        SizedBox(height: 12.h),

        /// Primary Action Button
        CustomButton(
          label: _isSignUp ? 'Send Verification Code' : 'Continue with Email',
          onPressed: _onContinueWithEmail,
        ),

        if (!_isSignUp) ...[
          SizedBox(height: 12.h),
          CustomButton(
            prefixIcon: Assets.icons.face.svg(),
            backgroundColor: context.colors.background,
            foregroundColor: context.colors.textPrimary,
            bordersColor: context.colors.borderSecondary,
            label: 'Continue with Touch ID',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const TouchFaceIdSheet(),
              );
            },
          ),
        ],

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
          prefixIcon: Assets.icons.google.svg(),
          backgroundColor: context.colors.background,
          foregroundColor: context.colors.textPrimary,
          bordersColor: context.colors.borderSecondary,
          label: 'Continue with Google',
          onPressed: (){},
        ),

        SizedBox(height: 28.h),

        /// Switch between Sign In and Sign Up
        Center(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _isSignUp = !_isSignUp;
              });
            },
            child: RichText(
              text: TextSpan(
                text: _isSignUp
                    ? 'Already have an account? '
                    : "Don't have an account? ",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: context.colors.textSecondary,
                ),
                children: [
                  TextSpan(
                    text: _isSignUp ? 'Sign In' : 'Sign Up',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: context.colors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        SizedBox(height: 24.h),
      ],
    );
  }
}
