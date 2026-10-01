import 'package:equatable/equatable.dart';

import '../../../tracking/domain/entities/order_tracking_entity.dart';
import '../../domain/entities/order_chat_thread_entity.dart';

enum ChatStatus { initial, loading, success, failure }

class ChatState extends Equatable {
  final ChatStatus status;
  final String orderId;
  final OrderTrackingEntity? tracking;
  final OrderChatThreadEntity? thread;
  final bool isSending;
  final String? errorMessage;
  final String? sendErrorMessage;

  const ChatState({
    this.status = ChatStatus.initial,
    this.orderId = '',
    this.tracking,
    this.thread,
    this.isSending = false,
    this.errorMessage,
    this.sendErrorMessage,
  });

  ChatState copyWith({
    ChatStatus? status,
    String? orderId,
    OrderTrackingEntity? tracking,
    OrderChatThreadEntity? thread,
    bool? isSending,
    String? errorMessage,
    String? sendErrorMessage,
    bool clearError = false,
    bool clearSendError = false,
  }) {
    return ChatState(
      status: status ?? this.status,
      orderId: orderId ?? this.orderId,
      tracking: tracking ?? this.tracking,
      thread: thread ?? this.thread,
      isSending: isSending ?? this.isSending,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      sendErrorMessage:
          clearSendError ? null : (sendErrorMessage ?? this.sendErrorMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        orderId,
        tracking,
        thread,
        isSending,
        errorMessage,
        sendErrorMessage,
      ];
}
