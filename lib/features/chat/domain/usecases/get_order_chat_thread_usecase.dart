import '../entities/order_chat_thread_entity.dart';
import '../repositories/i_chat_repository.dart';

class GetOrderChatThreadUseCase {
  final IChatRepository _repository;

  GetOrderChatThreadUseCase(this._repository);

  Stream<OrderChatThreadEntity> call(String orderId) {
    return _repository.getOrderChatThread(orderId);
  }
}
