import 'package:flutter_test/flutter_test.dart';
import 'package:cheering/features/chat/domain/entities/chat_message_entity.dart';
import 'package:cheering/features/chat/domain/entities/order_chat_thread_entity.dart';
import 'package:cheering/features/chat/domain/entities/send_message_result_entity.dart';
import 'package:cheering/features/chat/domain/repositories/i_chat_repository.dart';
import 'package:cheering/features/chat/domain/usecases/get_order_chat_thread_usecase.dart';
import 'package:cheering/features/chat/domain/usecases/send_chat_message_usecase.dart';
import 'package:cheering/features/chat/data/models/order_chat_thread_model.dart';
import 'package:cheering/features/chat/data/models/send_message_result_model.dart';

void main() {
  group('Chat Models Parsing', () {
    test('OrderChatThreadModel fromJson parses GET response data correctly', () {
      final json = {
        "order_id": "cf78f7b8-a88a-4d7a-8201-f0b484eeea50",
        "is_open": true,
        "closed_reason": null,
        "counterparty_name": "Rider Hridoy",
        "counterparty_role": "RIDER",
        "counterparty_avatar_url": null,
        "unread_count": 0,
        "messages": [
          {
            "id": "f4ae0cc8-729b-4968-819d-b10a6b4cc330",
            "order_id": "cf78f7b8-a88a-4d7a-8201-f0b484eeea50",
            "sender_role": "CUSTOMER",
            "sender_name": "Tanvir",
            "body": "hy tanvir",
            "created_at": "2026-09-30T05:36:07.945609+00:00",
            "read_at": null,
            "is_mine": true
          },
          {
            "id": "5810a840-8c12-4124-afea-6fba75003bac",
            "order_id": "cf78f7b8-a88a-4d7a-8201-f0b484eeea50",
            "sender_role": "CUSTOMER",
            "sender_name": "Tanvir",
            "body": "hy tanvir",
            "created_at": "2026-09-30T05:36:39.777998+00:00",
            "read_at": null,
            "is_mine": true
          }
        ]
      };

      final model = OrderChatThreadModel.fromJson(json);

      expect(model.orderId, 'cf78f7b8-a88a-4d7a-8201-f0b484eeea50');
      expect(model.isOpen, true);
      expect(model.closedReason, isNull);
      expect(model.counterpartyName, 'Rider Hridoy');
      expect(model.counterpartyRole, 'RIDER');
      expect(model.unreadCount, 0);
      expect(model.messages.length, 2);
      expect(model.messages.first.senderRole, 'CUSTOMER');
      expect(model.messages.first.body, 'hy tanvir');
      expect(model.messages.first.isMine, true);
    });

    test('SendMessageResultModel fromJson parses POST response data correctly', () {
      final json = {
        "message": {
          "id": "df79eb22-88dd-4861-81ed-0a67f410a204",
          "order_id": "cf78f7b8-a88a-4d7a-8201-f0b484eeea50",
          "sender_role": "CUSTOMER",
          "sender_name": "Tanvir",
          "body": "hy there",
          "created_at": "2026-10-01T04:33:59.649856+00:00",
          "read_at": null,
          "is_mine": true
        },
        "delivered_over_websocket": true
      };

      final model = SendMessageResultModel.fromJson(json);

      expect(model.deliveredOverWebsocket, true);
      expect(model.message.id, 'df79eb22-88dd-4861-81ed-0a67f410a204');
      expect(model.message.orderId, 'cf78f7b8-a88a-4d7a-8201-f0b484eeea50');
      expect(model.message.body, 'hy there');
      expect(model.message.isMine, true);
    });
  });

  group('Chat UseCases', () {
    test('GetOrderChatThreadUseCase delegates to repository', () async {
      final mockRepo = _MockChatRepository();
      final useCase = GetOrderChatThreadUseCase(mockRepo);

      final result = await useCase('order-123').first;

      expect(result.orderId, 'order-123');
      expect(mockRepo.calledOrderId, 'order-123');
    });

    test('SendChatMessageUseCase delegates to repository', () async {
      final mockRepo = _MockChatRepository();
      final useCase = SendChatMessageUseCase(mockRepo);

      final result = await useCase(orderId: 'order-123', body: 'test message');

      expect(result.deliveredOverWebsocket, true);
      expect(mockRepo.sentOrderId, 'order-123');
      expect(mockRepo.sentBody, 'test message');
    });
  });
}

class _MockChatRepository implements IChatRepository {
  String? calledOrderId;
  String? sentOrderId;
  String? sentBody;

  @override
  Stream<OrderChatThreadEntity> getOrderChatThread(String orderId) async* {
    calledOrderId = orderId;
    yield OrderChatThreadEntity(
      orderId: orderId,
      isOpen: true,
      counterpartyName: 'Rider Hridoy',
      counterpartyRole: 'RIDER',
      unreadCount: 0,
      messages: const [],
    );
  }

  @override
  Future<SendMessageResultEntity> sendMessage({
    required String orderId,
    required String body,
  }) async {
    sentOrderId = orderId;
    sentBody = body;
    return SendMessageResultEntity(
      message: ChatMessageEntity(
        id: 'msg-1',
        orderId: orderId,
        senderRole: 'CUSTOMER',
        senderName: 'Tanvir',
        body: body,
        createdAt: DateTime.now(),
        isMine: true,
      ),
      deliveredOverWebsocket: true,
    );
  }
}
