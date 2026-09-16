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

class AboutScreen extends StatefulWidget {
  final String email;
  final String otp;
  final String password;

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

  @override
  void dispose() {
    _nameController.dispose();
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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        switch ((state.status, state.action)) {
          case (AuthStatus.failure, AuthAction.verifyOtp):
            ToastMessageHelper.show(
              state.errorMessage ??
                  'Account verification failed. Please try again.',
            );
          case (AuthStatus.success, AuthAction.verifyOtp):
            context.push(
              AuthRedirect.withRedirectFromContext(
                context,
                RoutePaths.enableBiometrics,
              ),
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
            title: 'Tell us about you',
            subtitle: 'Enter your name to finish creating your account.',
          ),
        ),
        bodyList: [
          SizedBox(height: 16.h),
          Form(
            key: _formKey,
            child: CustomTextField(
              controller: _nameController,
              labelText: 'Your Name',
              hintText: 'e.g. Tanvir Hridoy',
              textInputAction: TextInputAction.done,
            ),
          ),
          SizedBox(height: 24.h),
          BlocBuilder<AuthBloc, AuthState>(
            buildWhen: (prev, curr) =>
                prev.isVerifyOtpLoading != curr.isVerifyOtpLoading,
            builder: (context, state) {
              return CustomButton(
                label: 'Confirm',
                isLoading: state.isVerifyOtpLoading,
                onPressed: _onSubmit,
              );
            },
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
