import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cheering/core/theme/app_theme_colors.dart';

class ChatBubbleMessage extends StatelessWidget {
  final String time;
  final String? text;
  final List<String>? images;
  final bool isSeen;
  final bool isMe;
  final String status;

  const ChatBubbleMessage({
    super.key,
    required this.time,
    this.text,
    this.images,
    required this.isMe,
    this.isSeen = false,
    this.status = 'offline',
  });

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isMe ? context.colors.primary : context.colors.white;
    final textColor = isMe ? Colors.white : context.colors.textPrimary;
    final timeColor = isMe
        ? Colors.white.withValues(alpha: 0.85)
        : context.colors.textTertiary;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 16.w),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 0.78.sw,
            minWidth: 72.w,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: isMe
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildMessageContent(textColor),
                SizedBox(height: 4.h),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment:
                      isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                        color: timeColor,
                      ),
                    ),
                    if (isMe) ...[
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.check,
                        size: 13.r,
                        color: Colors.white,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageContent(Color textColor) {
    if (text?.isNotEmpty == true) {
      return Text(
        text!,
        textAlign: isMe ? TextAlign.right : TextAlign.left,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: textColor,
          height: 1.35,
        ),
      );
    } else if (images != null && images!.isNotEmpty) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: images!.map((url) {
            return Padding(
              padding: EdgeInsets.only(right: 6.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: SizedBox(
                  width: 180.w,
                  height: 120.w,
                  child: Image.network(
                    url,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
