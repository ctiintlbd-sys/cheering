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

class AboutScreen extends StatefulWidget {
  final String email, otp, password;

  const AboutScreen({
    super.key,
    required this.email,
    required this.otp,
    required this.password,
  });

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<AuthBloc>().add(
          VerifyOtpRequested(
            email: widget.email,
            code: widget.otp,
            password: widget.password,
            fullName: _nameController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.failure &&
            state.action == AuthAction.verifyOtp) {
          ToastMessageHelper.show(
            state.errorMessage ?? 'Account verification failed. Please try again.',
          );
        } else if (state.status == AuthStatus.success &&
            state.action == AuthAction.verifyOtp) {
          ToastMessageHelper.show(
            state.successMessage ?? 'Account created successfully!',
          );
          context.push(RoutePaths.enableBiometrics);
        }
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: SliverScaffold(
            sideContentPadding: 24.w,
            appBar: CustomSliverAppBar(
              backgroundColor: context.colors.background.withValues(alpha: 0.4),
              expandedHeight: 180.h,
              flexibleChild: AppAuthTitle(
                title: 'Tell us about you',
                subtitle:
                    'Please enter your personal details to finish creating your account.',
              ),
            ),
            bodyList: [
              SizedBox(height: 16.h),

              CustomTextField(
                controller: _nameController,
                labelText: 'Your Name',
                hintText: 'e.g. Tanvir Hridoy',
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),

              SizedBox(height: 24.h),
              CustomTextField(
                controller: _numberController,
                keyboardType: TextInputType.phone,
                labelText: 'Phone Number',
                hintText: '01***********',
                validatorType: ValidatorType.phone,
              ),

              SizedBox(height: 24.h),

              CustomButton(
                label: 'Confirm',
                isLoading: state.isVerifyOtpLoading,
                onPressed: _onSubmit,
              ),

              SizedBox(height: 24.h),
            ],
          ),
        );
      },
    );
  }
}
