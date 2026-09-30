import 'package:cheering/core/helpers/toast_message_helper.dart';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:cheering/core/widgets/widgets.dart';
import 'package:cheering/features/tracking/domain/entities/order_tracking_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatMessageItem {
  final String id;
  final String text;
  final String time;
  final bool isMe;
  final bool isSeen;

  ChatMessageItem({
    required this.id,
    required this.text,
    required this.time,
    required this.isMe,
    this.isSeen = true,
  });
}

class RiderChatScreen extends StatefulWidget {
  final TrackingRiderEntity? rider;

  const RiderChatScreen({super.key, this.rider});

  @override
  State<RiderChatScreen> createState() => _RiderChatScreenState();
}

class _RiderChatScreenState extends State<RiderChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showCallMenu = false;

  late final List<ChatMessageItem> _messages;

  @override
  void initState() {
    super.initState();
    _messages = [
      ChatMessageItem(
        id: '1',
        text: 'Hey there! 👋',
        time: '10:10',
        isMe: false,
      ),
      ChatMessageItem(
        id: '2',
        text:
            "This is your delivery driver from Quick Food. I'm just around the corner from your place. 😊",
        time: '10:10',
        isMe: false,
      ),
      ChatMessageItem(
        id: '3',
        text: 'Hi!',
        time: '10:10',
        isMe: true,
        isSeen: true,
      ),
      ChatMessageItem(
        id: '4',
        text:
            "Awesome, thanks for letting me know! Can't wait for my delivery. 🎉",
        time: '10:11',
        isMe: true,
        isSeen: true,
      ),
      ChatMessageItem(
        id: '5',
        text: "No problem at all! I'll be there in about 15 minutes.",
        time: '10:11',
        isMe: false,
      ),
      ChatMessageItem(
        id: '6',
        text: 'Great! 😊',
        time: '10:12',
        isMe: true,
        isSeen: true,
      ),
    ];
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final now = DateTime.now();
    final formattedTime =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    setState(() {
      _messages.add(
        ChatMessageItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: text,
          time: formattedTime,
          isMe: true,
          isSeen: true,
        ),
      );
      _textController.clear();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _makeCellularCall() async {
    setState(() => _showCallMenu = false);
    final phone = widget.rider?.phone?.trim() ?? '';
    if (phone.isNotEmpty) {
      final uri = Uri(scheme: 'tel', path: phone);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return;
      }
    }
    ToastMessageHelper.show('Cellular call is not available');
  }

  void _makeInAppCall() {
    setState(() => _showCallMenu = false);
    ToastMessageHelper.show('Connecting in-app call...');
  }

  @override
  Widget build(BuildContext context) {
    final rider = widget.rider;
    final riderName =
        (rider?.name.isNotEmpty ?? false) ? rider!.name : 'Jayed Khan';
    final riderRating =
        rider?.ratingAvg != null ? rider!.ratingAvg!.toStringAsFixed(1) : '4.9';
    final riderId = (rider != null && rider.id.length >= 6)
        ? 'ID ${rider.id.substring(rider.id.length - 6).toUpperCase()}'
        : (rider?.id.isNotEmpty ?? false ? 'ID ${rider!.id}' : 'ID DW2125');

    return Scaffold(
      backgroundColor: context.colors.bgSecondary,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.h),
        child: Container(
          color: context.colors.white,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                children: [
                  CustomContainer(
                    onTap: () => context.pop(),
                    width: 38.r,
                    height: 38.r,
                    shape: BoxShape.circle,
                    color: context.colors.white,
                    bordersColor: context.colors.borderTertiary,
                    alignment: Alignment.center,
                    child: Assets.icons.arrowBack.svg(
                      width: 18.r,
                      height: 18.r,
                      colorFilter: ColorFilter.mode(
                        context.colors.textPrimary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  CustomNetworkImage(
                    width: 44.r,
                    height: 44.r,
                    boxShape: BoxShape.circle,
                    imageUrl: rider?.photoUrl,
                    fallbackAsset: ClipOval(
                      child: Assets.images.rateRiderAvatar.image(
                        width: 44.r,
                        height: 44.r,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: riderName,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: context.colors.textPrimary,
                          maxLines: 1,
                        ),
                        SizedBox(height: 3.h),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: 14.r,
                              color: context.colors.ratingColor,
                            ),
                            SizedBox(width: 3.w),
                            CustomText(
                              text: riderRating,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: context.colors.textSecondary,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6.w),
                              child: CustomText(
                                text: '•',
                                fontSize: 12.sp,
                                color: context.colors.textTertiary,
                              ),
                            ),
                            CustomText(
                              text: riderId,
                              fontSize: 12.sp,
                              color: context.colors.textTertiary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  CustomContainer(
                    onTap: () {
                      setState(() {
                        _showCallMenu = !_showCallMenu;
                      });
                    },
                    width: 40.r,
                    height: 40.r,
                    shape: BoxShape.circle,
                    color: context.colors.white,
                    bordersColor: context.colors.borderTertiary,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.phone_outlined,
                      size: 20.r,
                      color: context.colors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    return ChatBubbleMessage(
                      key: ValueKey(msg.id),
                      time: msg.time,
                      text: msg.text,
                      isMe: msg.isMe,
                      isSeen: msg.isSeen,
                    );
                  },
                ),
                if (_showCallMenu) ...[
                  Positioned.fill(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => setState(() => _showCallMenu = false),
                      child: const SizedBox.expand(),
                    ),
                  ),
                  Positioned(
                    top: 4.h,
                    right: 16.w,
                    child: _buildCallMenu(context),
                  ),
                ],
              ],
            ),
          ),
          _buildBottomInput(context),
        ],
      ),
    );
  }

  Widget _buildCallMenu(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: Container(
        width: 190.w,
        decoration: BoxDecoration(
          color: context.colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: _makeInAppCall,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                child: Row(
                  children: [
                    Icon(
                      Icons.wifi_calling_3_outlined,
                      size: 20.r,
                      color: context.colors.textPrimary,
                    ),
                    SizedBox(width: 12.w),
                    CustomText(
                      text: 'In app call',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: context.colors.textPrimary,
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              height: 1,
              thickness: 0.8,
              color: context.colors.outline.withValues(alpha: 0.6),
            ),
            InkWell(
              onTap: _makeCellularCall,
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(16.r)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                child: Row(
                  children: [
                    Icon(
                      Icons.signal_cellular_alt_rounded,
                      size: 20.r,
                      color: context.colors.textPrimary,
                    ),
                    SizedBox(width: 12.w),
                    CustomText(
                      text: 'Cellular call',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: context.colors.textPrimary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomInput(BuildContext context) {
    return Container(
      color: context.colors.white,
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            InkWell(
              onTap: () {
                ToastMessageHelper.show('Attachments coming soon');
              },
              borderRadius: BorderRadius.circular(20.r),
              child: Padding(
                padding: EdgeInsets.all(6.r),
                child: Icon(
                  Icons.add,
                  size: 26.r,
                  color: context.colors.textPrimary,
                ),
              ),
            ),
            SizedBox(width: 8.w),
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
                  controller: _textController,
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
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                width: 44.r,
                height: 44.r,
                decoration: const BoxDecoration(
                  color: Color(0xFF0F172A),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: SvgPicture.string(
                  '''<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#FFFFFF" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="22" y1="2" x2="11" y2="13"></line>
                    <polygon points="22 2 15 22 11 13 2 9 22 2"></polygon>
                  </svg>''',
                  width: 20.r,
                  height: 20.r,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
