import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/utils/assets/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ToastMessageHelper {
  ToastMessageHelper._();

  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static const Duration _cooldown = Duration(seconds: 2);
  static String? _lastMessage;
  static DateTime? _lastShownAt;

  static void show(String message) {
    if (message.trim().isEmpty) return;
    final now = DateTime.now();

    if (_lastMessage == message &&
        _lastShownAt != null &&
        now.difference(_lastShownAt!) < _cooldown) {
      return;
    }

    final messenger = messengerKey.currentState;
    if (messenger == null) return;

    _lastMessage = message;
    _lastShownAt = now;

    messenger
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          backgroundColor: Colors.white,
          elevation: 1,
          dismissDirection: DismissDirection.horizontal,
          showCloseIcon: true,
          closeIconColor: const Color(0xFF0F172A),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Assets.images.appLogo.image(height: 24.w, width: 24.w),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    fontFamily: FontFamily.sFPro,
                    fontSize: 14.r,
                    color: Color(0xFF0F172A),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
            side: const BorderSide(color: Colors.white, width: 0.8),
          ),
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
          duration: const Duration(seconds: 3),
        ),
      );
  }
}
