import 'dart:math' as math;

import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/widgets/widgets.dart';

class ChatInputBar extends StatefulWidget {
  final String? closedReason;
  final ValueChanged<String> onSend;
  final VoidCallback? onInputTap;

  const ChatInputBar({
    super.key,
    this.closedReason,
    required this.onSend,
    this.onInputTap,
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
    final viewInsetsBottom = MediaQuery.viewInsetsOf(context).bottom;
    final viewPaddingBottom = MediaQuery.viewPaddingOf(context).bottom;
    final bottomInset = math.max(viewInsetsBottom, viewPaddingBottom);
    return Container(
      color: context.colors.white,
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h + bottomInset),
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              contentPaddingVertical: 12.w,
              borderColor: context.colors.bgSecondary,
              validator: (_) => null,
              fillColor: context.colors.bgSecondary,
              controller: _controller,
              onTap: widget.onInputTap,
              hintText: 'Type a message ...',
            ),
          ),
          SizedBox(width: 12.w),
          GestureDetector(
            onTap: _handleSend,
            child: Assets.icons.sendMessage.svg(),
          ),
        ],
      ),
    );
  }
}
