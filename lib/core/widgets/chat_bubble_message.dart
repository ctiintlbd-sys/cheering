import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/widgets.dart';

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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isMe
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              Flexible(
                child: CustomContainer(
                  paddingAll: 10.r,
                  color: isMe
                      ? Colors.white
                      : Colors.black.withValues(alpha: 0.08),
                  bottomRight: 10.r,
                  bottomLeft: 10.r,
                  topLeftRadius: isMe ? 10.r : 0,
                  topRightRadius: !isMe ? 10.r : 0,
                  child: _buildMessageContent(),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: isMe
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              CustomText(
                top: 3.h,
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
                text: time,
                left: isMe ? 0 : 10.w,
                right: isMe ? 10.w : 0,
                color: Colors.grey.shade500,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageContent() {
    if (text?.isNotEmpty == true) {
      return CustomText(
        maxLines: 10,
        textAlign: TextAlign.left,
        fontWeight: FontWeight.w500,
        text: text!,
      );
    } else if (images != null && images!.isNotEmpty) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: images!.map((url) {
            return Padding(
              padding: EdgeInsets.only(right: 5.h),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: SizedBox(
                  width: 180.w,
                  height: 120.h,
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
    return const SizedBox();
  }
}
