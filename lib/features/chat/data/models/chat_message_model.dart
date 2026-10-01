import '../../domain/entities/chat_message_entity.dart';

class ChatMessageModel extends ChatMessageEntity {
  const ChatMessageModel({
    required super.id,
    required super.orderId,
    required super.senderRole,
    required super.senderName,
    required super.body,
    required super.createdAt,
    super.readAt,
    required super.isMine,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as String? ?? '',
      orderId: json['order_id'] as String? ?? '',
      senderRole: json['sender_role'] as String? ?? '',
      senderName: json['sender_name'] as String? ?? '',
      body: json['body'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)?.toLocal() ??
              DateTime.now()
          : DateTime.now(),
      readAt: json['read_at'] != null
          ? DateTime.tryParse(json['read_at'] as String)?.toLocal()
          : null,
      isMine: json['is_mine'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'sender_role': senderRole,
      'sender_name': senderName,
      'body': body,
      'created_at': createdAt.toUtc().toIso8601String(),
      'read_at': readAt?.toUtc().toIso8601String(),
      'is_mine': isMine,
    };
  }
}
