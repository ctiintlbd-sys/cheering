import '../entities/order_chat_thread_entity.dart';
import '../entities/send_message_result_entity.dart';

abstract class IChatRepository {
  Stream<OrderChatThreadEntity> getOrderChatThread(String orderId);

  Future<OrderChatThreadEntity> fetchOrderChatThread(String orderId);

  Future<SendMessageResultEntity> sendMessage({
    required String orderId,
    required String body,
  });
}
