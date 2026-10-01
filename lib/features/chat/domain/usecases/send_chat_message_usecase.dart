import '../entities/send_message_result_entity.dart';
import '../repositories/i_chat_repository.dart';

class SendChatMessageUseCase {
  final IChatRepository _repository;

  SendChatMessageUseCase(this._repository);

  Future<SendMessageResultEntity> call({
    required String orderId,
    required String body,
  }) {
    return _repository.sendMessage(orderId: orderId, body: body);
  }
}
