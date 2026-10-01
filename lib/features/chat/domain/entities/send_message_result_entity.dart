import 'package:equatable/equatable.dart';

import 'chat_message_entity.dart';

class SendMessageResultEntity extends Equatable {
  final ChatMessageEntity message;
  final bool deliveredOverWebsocket;

  const SendMessageResultEntity({
    required this.message,
    required this.deliveredOverWebsocket,
  });

  SendMessageResultEntity copyWith({
    ChatMessageEntity? message,
    bool? deliveredOverWebsocket,
  }) {
    return SendMessageResultEntity(
      message: message ?? this.message,
      deliveredOverWebsocket:
          deliveredOverWebsocket ?? this.deliveredOverWebsocket,
    );
  }

  @override
  List<Object?> get props => [message, deliveredOverWebsocket];
}
