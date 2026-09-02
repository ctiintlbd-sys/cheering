import 'dart:async';
import 'package:cheering/core/router/route_args.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/helpers/toast_message_helper.dart';
import '../../../../core/widgets/widgets.dart';
import 'package:cheering/core/widgets/app_auth_title.dart';

class OtpScreen extends StatefulWidget {
  final OtpScreenArgs args;

  const OtpScreen({super.key, required this.args});

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
    final code = _otpController.text.trim();
    if (code.isEmpty) {
      ToastMessageHelper.show('Please enter OTP code');
      return;
    }

    if (widget.args.isLoading) return;
    widget.args.onConfirm(code);
  }

  void _onResend(BuildContext context) {
    if (_countdownNotifier.value > 0 || widget.args.isResending) return;
    widget.args.onResend();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      appBar: CustomSliverAppBar(
        expandedHeight: 180.h,
        flexibleChild: AppAuthTitle(
          title: 'Enter OTP',
          subtitle: 'We have sent a verification code to ${widget.args.email}',
        ),
      ),
      bodyList: [
        SizedBox(height: 24.h).asSliver,

        /// PinCode Input Field
        Center(
          child: CustomPinCodeTextField(
            controller: _otpController,
            onCompleted: (pin) {
              _onConfirm(context);
            },
          ),
        ).asSliverWithPadding(horizontal: 24.w),

        SizedBox(height: 32.h).asSliver,

        /// Confirm CTA Button
        CustomButton(
          label: 'Confirm & Submit',
          isLoading: widget.args.isLoading,
          onPressed: widget.args.isLoading ? null : () => _onConfirm(context),
        ).asSliverWithPadding(horizontal: 24.w),

        SizedBox(height: 24.h).asSliver,

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
                  text: isCounting ? 'Resend in (${seconds}s)' : 'Resend Code',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: isCounting
                      ? context.colors.textPlaceholder
                      : context.colors.primary,
                  onTap: (!isCounting && !widget.args.isResending)
                      ? () => _onResend(context)
                      : null,
                );
              },
            ),
          ],
        ).asSliverWithPadding(horizontal: 24.w),

        SizedBox(height: 32.h).asSliver,
      ],
    );
  }
}
