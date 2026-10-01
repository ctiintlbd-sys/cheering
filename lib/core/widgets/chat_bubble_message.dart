import 'package:cheering/core/utils/assets/fonts.gen.dart';
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
    final bubbleColor = isMe ? context.colors.primary : context.colors.background;
    final textColor = isMe ? context.colors.white : context.colors.textPrimary;
    final timeColor = isMe
        ? context.colors.white.withValues(alpha: 0.7)
        : context.colors.textTertiary;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 16.w),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
              bottomLeft: Radius.circular(isMe ? 16.r : 0),
              bottomRight: Radius.circular(isMe ? 0 : 16.r),
            )
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
                      fontSize: 14.w,
                      fontWeight: FontWeight.w400,
                      fontFamily: FontFamily.sFPro,
                      color: timeColor,
                    ),
                  ),
                  if (isMe) ...[
                    SizedBox(width: 4.w),
                    if (status == 'pending')
                      Icon(
                        Icons.access_time_rounded,
                        size: 12.r,
                        color: timeColor,
                      )
                    else if (status == 'failed')
                      Icon(
                        Icons.error_outline_rounded,
                        size: 12.r,
                        color: timeColor,
                      )
                    else if (isSeen)
                      Icon(
                        Icons.done_all,
                        size: 12.r,
                        color: timeColor,
                      )
                    else
                      Icon(
                        Icons.check,
                        size: 12.r,
                        color: timeColor,
                      ),
                  ],
                ],
              ),
            ],
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
          fontSize: 16.w,
          fontWeight: FontWeight.w400,
          fontFamily: FontFamily.sFPro,
          color: textColor,
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
