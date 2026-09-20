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
          backgroundColor: const Color(0xFF0F172A),
          elevation: 4,
          dismissDirection: DismissDirection.horizontal,
          showCloseIcon: true,
          closeIconColor: const Color(0xFF94A3B8),
          content: Text(
            message,
            style: TextStyle(
              fontSize: 13.r,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
            side: const BorderSide(color: Color(0xFF1E293B), width: 0.8),
          ),
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
          duration: const Duration(seconds: 3),
        ),
      );
  }
}
