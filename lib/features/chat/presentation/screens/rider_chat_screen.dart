import 'dart:async';
import 'package:cheering/core/utils/assets/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/helpers/toast_message_helper.dart';
import '../../../../core/utils/app_date_formatter.dart';
import '../../../../core/widgets/widgets.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import 'widgets/chat_app_bar.dart';
import 'widgets/chat_input_bar.dart';
import 'widgets/chat_loading_widget.dart';

class RiderChatScreen extends StatefulWidget {
  const RiderChatScreen({super.key});

  @override
  State<RiderChatScreen> createState() => _RiderChatScreenState();
}

class _RiderChatScreenState extends State<RiderChatScreen> {
  final ScrollController _scrollController = ScrollController();
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final state = context.read<ChatBloc>().state;
      if (state.orderId.isNotEmpty && (state.thread?.isOpen ?? true)) {
       // context.read<ChatBloc>().add(PollChatThread(state.orderId));
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(String orderId, String body) {
    context.read<ChatBloc>().add(
          SendMessageEvent(orderId: orderId, body: body),
        );
    _scrollToBottom();
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
        return SliverScaffold(
          backgroundColor: context.colors.bgSecondary,
          scrollController: _scrollController,
          isNavWrap: false,
          extendBody: false,
          appBar: ChatAppBar(
            rider: rider,
          ),
          bodyList: switch (state.status) {
            ChatStatus.initial ||
            ChatStatus.loading  => [
              const ChatLoadingWidget(),
            ],
            ChatStatus.failure  => [
              EmptyState(
                icon: Assets.icons.chat.svg(),
                message: state.errorMessage ?? 'Failed to load conversation',
              ),
            ],

            ChatStatus.success when (state.thread?.messages.isEmpty ?? true) => [
              EmptyState(
                icon: Assets.icons.chat.svg(),
                message: 'No messages yet',
              ),
            ],
            ChatStatus.success => [
              SliverList.builder(
                itemCount: state.thread!.messages.length,
                itemBuilder: (context, index) {
                  final msg = state.thread!.messages[index];
                  final timeStr = AppDateFormatter.formatTime(msg.createdAt);
                  return ChatBubbleMessage(
                    key: ValueKey(msg.id),
                    time: timeStr,
                    text: msg.body,
                    isMe: msg.isMine,
                    isSeen: msg.readAt != null,
                    status: msg.isSending
                        ? 'pending'
                        : (msg.isFailed ? 'failed' : 'sent'),
                  );
                },
              ),
              SizedBox(height: 16.h),
            ],
          },
          bottomNavigationBar: ChatInputBar(
            closedReason: thread?.closedReason,
            onSend: (text) => _sendMessage(state.orderId, text),
            onInputTap: () {
              Future.delayed(const Duration(milliseconds: 300), () {
                _scrollToBottom();
              });
            },
          ),
        );
      },
    );
  }
}
