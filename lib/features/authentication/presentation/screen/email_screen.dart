import 'package:cheering/core/router/route_paths.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/core/utils/validators.dart';
import 'package:cheering/core/widgets/app_auth_title.dart';
import 'package:cheering/features/authentication/presentation/screen/widgets/touch_face_id_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class EmailScreen extends StatefulWidget {
  const EmailScreen({super.key});

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onContinueWithEmail() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.push(RoutePaths.password);
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
          subtitle: 'Enter your email and password to sign in',
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

        /// Login Button
        CustomButton(
          label: 'Continue with Email',
          onPressed: _onContinueWithEmail,
        ),

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
          label: 'Continue with phone',
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
