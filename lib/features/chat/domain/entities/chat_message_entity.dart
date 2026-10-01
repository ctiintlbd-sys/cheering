import 'package:equatable/equatable.dart';

class ChatMessageEntity extends Equatable {
  final String id;
  final String orderId;
  final String senderRole;
  final String senderName;
  final String body;
  final DateTime createdAt;
  final DateTime? readAt;
  final bool isMine;

  const ChatMessageEntity({
    required this.id,
    required this.orderId,
    required this.senderRole,
    required this.senderName,
    required this.body,
    required this.createdAt,
    this.readAt,
    required this.isMine,
  });

  ChatMessageEntity copyWith({
    String? id,
    String? orderId,
    String? senderRole,
    String? senderName,
    String? body,
    DateTime? createdAt,
    DateTime? readAt,
    bool? isMine,
  }) {
    return ChatMessageEntity(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      senderRole: senderRole ?? this.senderRole,
      senderName: senderName ?? this.senderName,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
      isMine: isMine ?? this.isMine,
    );
  }

  @override
  List<Object?> get props => [
        id,
        orderId,
        senderRole,
        senderName,
        body,
        createdAt,
        readAt,
        isMine,
      ];
}
