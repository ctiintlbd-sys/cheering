import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/widgets/widgets.dart';

class ChatInputBar extends StatefulWidget {
  final String? closedReason;
  final ValueChanged<String> onSend;

  const ChatInputBar({
    super.key,
    this.closedReason,
    required this.onSend,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    widget.onSend(text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.white,
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 44.h,
                decoration: BoxDecoration(
                  color: context.colors.bgSecondary,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                alignment: Alignment.center,
                child: TextField(
                  controller: _controller,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: context.colors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Type a message ...',
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      color: context.colors.textPlaceholder,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onSubmitted: (_) => _handleSend(),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            GestureDetector(
              onTap: _handleSend,
              child: Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  color: context.colors.primary,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 20.r,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
