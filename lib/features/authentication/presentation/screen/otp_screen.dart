import 'dart:async';
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

class OtpScreen extends StatefulWidget {
  final String email;
  final bool isForgotPassword;

  const OtpScreen({
    super.key,
    required this.email,
    this.isForgotPassword = false,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  final ValueNotifier<int> _countdownNotifier = ValueNotifier<int>(30);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _countdownNotifier.value = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdownNotifier.value > 0) {
        _countdownNotifier.value--;
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    _countdownNotifier.dispose();
    super.dispose();
  }

  void _onConfirm(BuildContext context) {
    final otp = _otpController.text.trim();
    context.push(
      AuthRedirect.withRedirectFromContext(context, RoutePaths.setPassword),
      extra: {
        'email': widget.email,
        'otp': otp,
        'isForgotPassword': widget.isForgotPassword,
      },
    );
  }

  void _onResend(BuildContext context) {
    if (_countdownNotifier.value > 0) return;
    _startTimer();
    if (widget.isForgotPassword) {
      context.read<AuthBloc>().add(
        ForgotPasswordRequested(email: widget.email),
      );
    } else {
      context.read<AuthBloc>().add(SendOtpRequested(email: widget.email));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (prev, curr) =>
          curr.status == AuthStatus.failure &&
          (curr.action == AuthAction.sendOtp ||
              curr.action == AuthAction.forgotPassword),
      listener: (context, state) {
        ToastMessageHelper.show(state.errorMessage ?? 'Failed to resend code');
      },
      child: SliverScaffold(
        sideContentPadding: 24.w,
        appBar: CustomSliverAppBar(
          expandedHeight: 144.h,
          flexibleChild: AppAuthTitle(
            title: 'Enter OTP',
            subtitle: 'We have sent a verification code to ${widget.email}',
          ),
        ),
        bodyList: [
          SizedBox(height: 24.h),

          /// PinCode Input Field
          Center(child: CustomPinCodeTextField(controller: _otpController)),

          SizedBox(height: 32.h),

          /// Confirm CTA Button
          CustomButton(
            label: 'Confirm & Submit',
            onPressed: () => _onConfirm(context),
          ),

          SizedBox(height: 24.h),

          /// "Didn't receive code? Resend Code" Row with Timer
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: "Didn't receive code?",
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: context.colors.textSecondary,
              ),
              SizedBox(width: 6.w),
              ValueListenableBuilder<int>(
                valueListenable: _countdownNotifier,
                builder: (context, seconds, _) {
                  final isCounting = seconds > 0;
                  return CustomText(
                    text: isCounting
                        ? 'Resend in (${seconds}s)'
                        : 'Resend Code',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isCounting
                        ? context.colors.textPlaceholder
                        : context.colors.primary,
                    onTap: () => _onResend(context),
                  );
                },
              ),
            ],
          ),

          SizedBox(height: 32.h),
        ],
      ),
    );
  }
}
