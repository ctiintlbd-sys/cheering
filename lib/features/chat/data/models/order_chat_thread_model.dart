import '../../domain/entities/order_chat_thread_entity.dart';
import 'chat_message_model.dart';

class OrderChatThreadModel extends OrderChatThreadEntity {
  const OrderChatThreadModel({
    required super.orderId,
    required super.isOpen,
    super.closedReason,
    required super.counterpartyName,
    required super.counterpartyRole,
    super.counterpartyAvatarUrl,
    required super.unreadCount,
    required super.messages,
  });

  factory OrderChatThreadModel.fromJson(Map<String, dynamic> json) {
    return OrderChatThreadModel(
      orderId: json['order_id'] as String? ?? '',
      isOpen: json['is_open'] == true,
      closedReason: json['closed_reason'] as String?,
      counterpartyName: json['counterparty_name'] as String? ?? '',
      counterpartyRole: json['counterparty_role'] as String? ?? '',
      counterpartyAvatarUrl: json['counterparty_avatar_url'] as String?,
      unreadCount: (json['unread_count'] as num?)?.toInt() ?? 0,
      messages: (json['messages'] as List<dynamic>?)
              ?.map((e) => ChatMessageModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'is_open': isOpen,
      'closed_reason': closedReason,
      'counterparty_name': counterpartyName,
      'counterparty_role': counterpartyRole,
      'counterparty_avatar_url': counterpartyAvatarUrl,
      'unread_count': unreadCount,
      'messages': messages
          .map(
            (e) => (e is ChatMessageModel
                    ? e
                    : ChatMessageModel(
                        id: e.id,
                        orderId: e.orderId,
                        senderRole: e.senderRole,
                        senderName: e.senderName,
                        body: e.body,
                        createdAt: e.createdAt,
                        readAt: e.readAt,
                        isMine: e.isMine,
                      ))
                .toJson(),
          )
          .toList(),
    };
  }
}
