import '../../domain/entities/send_message_result_entity.dart';
import 'chat_message_model.dart';

class SendMessageResultModel extends SendMessageResultEntity {
  const SendMessageResultModel({
    required super.message,
    required super.deliveredOverWebsocket,
  });

  factory SendMessageResultModel.fromJson(Map<String, dynamic> json) {
    final msgMap = json['message'] as Map<String, dynamic>? ?? {};
    return SendMessageResultModel(
      message: ChatMessageModel.fromJson(msgMap),
      deliveredOverWebsocket: json['delivered_over_websocket'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': (message is ChatMessageModel
              ? message as ChatMessageModel
              : ChatMessageModel(
                  id: message.id,
                  orderId: message.orderId,
                  senderRole: message.senderRole,
                  senderName: message.senderName,
                  body: message.body,
                  createdAt: message.createdAt,
                  readAt: message.readAt,
                  isMine: message.isMine,
                ))
          .toJson(),
      'delivered_over_websocket': deliveredOverWebsocket,
    };
  }
}
