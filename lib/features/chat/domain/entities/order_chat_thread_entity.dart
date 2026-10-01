import 'package:equatable/equatable.dart';

import 'chat_message_entity.dart';

class OrderChatThreadEntity extends Equatable {
  final String orderId;
  final bool isOpen;
  final String? closedReason;
  final String counterpartyName;
  final String counterpartyRole;
  final String? counterpartyAvatarUrl;
  final int unreadCount;
  final List<ChatMessageEntity> messages;

  const OrderChatThreadEntity({
    required this.orderId,
    required this.isOpen,
    this.closedReason,
    required this.counterpartyName,
    required this.counterpartyRole,
    this.counterpartyAvatarUrl,
    required this.unreadCount,
    required this.messages,
  });

  OrderChatThreadEntity copyWith({
    String? orderId,
    bool? isOpen,
    String? closedReason,
    String? counterpartyName,
    String? counterpartyRole,
    String? counterpartyAvatarUrl,
    int? unreadCount,
    List<ChatMessageEntity>? messages,
  }) {
    return OrderChatThreadEntity(
      orderId: orderId ?? this.orderId,
      isOpen: isOpen ?? this.isOpen,
      closedReason: closedReason ?? this.closedReason,
      counterpartyName: counterpartyName ?? this.counterpartyName,
      counterpartyRole: counterpartyRole ?? this.counterpartyRole,
      counterpartyAvatarUrl:
          counterpartyAvatarUrl ?? this.counterpartyAvatarUrl,
      unreadCount: unreadCount ?? this.unreadCount,
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object?> get props => [
        orderId,
        isOpen,
        closedReason,
        counterpartyName,
        counterpartyRole,
        counterpartyAvatarUrl,
        unreadCount,
        messages,
      ];
}
