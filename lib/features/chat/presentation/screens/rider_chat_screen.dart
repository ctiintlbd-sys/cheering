import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/helpers/toast_message_helper.dart';
import '../../../../core/utils/app_date_formatter.dart';
import '../../../../core/utils/assets/assets.gen.dart';
import '../../../../core/widgets/widgets.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';

class RiderChatScreen extends StatefulWidget {
  const RiderChatScreen({super.key});

  @override
  State<RiderChatScreen> createState() => _RiderChatScreenState();
}

class _RiderChatScreenState extends State<RiderChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
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

  void _sendMessage(String orderId) {
    final text = _textController.text.trim();
    if (text.isEmpty || orderId.isEmpty) return;

    context.read<ChatBloc>().add(
          SendMessageEvent(
            orderId: orderId,
            body: text,
          ),
        );
    _textController.clear();
    _scrollToBottom();
  }

  Future<void> _makeCellularCall(String? phone) async {
    final cleanPhone = phone?.trim() ?? '';
    if (cleanPhone.isNotEmpty) {
      final uri = Uri(scheme: 'tel', path: cleanPhone);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return;
      }
    }
    ToastMessageHelper.show('Cellular call is not available');
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state.sendErrorMessage != null) {
          ToastMessageHelper.show(state.sendErrorMessage!);
        }
        _scrollToBottom();
      },
      builder: (context, state) {
        final thread = state.thread;
        final rider = state.tracking?.rider;

        final riderName = (thread != null && thread.counterpartyName.isNotEmpty)
            ? thread.counterpartyName
            : ((rider?.name.isNotEmpty ?? false) ? rider!.name : 'Rider');

        final riderRating = rider?.ratingAvg != null
            ? rider!.ratingAvg!.toStringAsFixed(1)
            : '4.9';

        final riderSubtitle = (thread != null &&
                thread.counterpartyRole.isNotEmpty)
            ? thread.counterpartyRole
            : (rider != null && rider.id.length >= 6
                ? 'ID ${rider.id.substring(rider.id.length - 6).toUpperCase()}'
                : 'RIDER');

        final avatarUrl = thread?.counterpartyAvatarUrl ?? rider?.photoUrl;
        final isClosed = thread != null && !thread.isOpen;
        final phone = rider?.phone;

        return Scaffold(
          backgroundColor: context.colors.bgSecondary,
          appBar: _buildAppBar(
            context: context,
            riderName: riderName,
            riderRating: riderRating,
            riderSubtitle: riderSubtitle,
            avatarUrl: avatarUrl,
            phone: phone,
          ),
          body: Column(
            children: [
              Expanded(
                child: _buildChatBody(context, state),
              ),
              _buildBottomBar(
                context: context,
                isClosed: isClosed,
                isSending: state.isSending,
                closedReason: thread?.closedReason,
                orderId: state.orderId,
              ),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar({
    required BuildContext context,
    required String riderName,
    required String riderRating,
    required String riderSubtitle,
    String? avatarUrl,
    String? phone,
  }) {
    return PreferredSize(
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
                  imageUrl: avatarUrl,
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
                            text: riderSubtitle,
                            fontSize: 12.sp,
                            color: context.colors.textTertiary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                CustomContainer(
                  onTap: () => _makeCellularCall(phone),
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
    );
  }

  Widget _buildChatBody(BuildContext context, ChatState state) {
    if (state.status == ChatStatus.loading && state.thread == null) {
      return _buildLoadingShimmer(context);
    }

    if (state.status == ChatStatus.failure && state.thread == null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              EmptyState(
                message: state.errorMessage ?? 'Failed to load conversation',
              ),
              if (state.orderId.isNotEmpty) ...[
                SizedBox(height: 12.h),
                CustomButton(
                  text: 'Retry',
                  width: 120.w,
                  height: 38.h,
                  onPressed: () {
                    context.read<ChatBloc>().add(
                          LoadChatThread(
                            orderId: state.orderId,
                            tracking: state.tracking,
                          ),
                        );
                  },
                ),
              ],
            ],
          ),
        ),
      );
    }

    final messages = state.thread?.messages ?? const [];

    if (messages.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.chat_bubble_outline_rounded,
                size: 48.r,
                color: context.colors.textTertiary,
              ),
              SizedBox(height: 12.h),
              CustomText(
                text: 'No messages yet',
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: context.colors.textSecondary,
              ),
              SizedBox(height: 4.h),
              CustomText(
                text: 'Send a message to coordinate your delivery.',
                fontSize: 12.sp,
                color: context.colors.textTertiary,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(vertical: 12.h),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        final timeStr = AppDateFormatter.formatTime(msg.createdAt);

        return ChatBubbleMessage(
          key: ValueKey(msg.id),
          time: timeStr,
          text: msg.body,
          isMe: msg.isMine,
          isSeen: msg.readAt != null,
        );
      },
    );
  }

  Widget _buildLoadingShimmer(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: 180.w,
            height: 46.h,
            decoration: BoxDecoration(
              color: context.colors.white,
              borderRadius: BorderRadius.circular(14.r),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: 140.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: context.colors.primary.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(14.r),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: 220.w,
            height: 52.h,
            decoration: BoxDecoration(
              color: context.colors.white,
              borderRadius: BorderRadius.circular(14.r),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar({
    required BuildContext context,
    required bool isClosed,
    required bool isSending,
    required String orderId,
    String? closedReason,
  }) {
    if (isClosed) {
      return Container(
        width: double.infinity,
        color: context.colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: SafeArea(
          top: false,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: context.colors.bgSecondary,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: context.colors.borderTertiary),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lock_outline_rounded,
                  size: 18.r,
                  color: context.colors.textSecondary,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: CustomText(
                    text: closedReason?.isNotEmpty == true
                        ? closedReason!
                        : 'This chat has closed because the order was completed.',
                    fontSize: 12.sp,
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

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
                  onSubmitted: (_) => _sendMessage(orderId),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            GestureDetector(
              onTap: isSending ? null : () => _sendMessage(orderId),
              child: Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  color: context.colors.primary,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: isSending
                    ? SizedBox(
                        width: 18.r,
                        height: 18.r,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Icon(
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
