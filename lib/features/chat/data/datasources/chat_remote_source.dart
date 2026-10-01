import '../../../../core/config/api_endpoints.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/i_api_client.dart';
import '../models/order_chat_thread_model.dart';
import '../models/send_message_result_model.dart';

class ChatRemoteSource {
  final IApiClient _apiClient;

  ChatRemoteSource(this._apiClient);

  Future<ApiResult<OrderChatThreadModel>> getOrderChatThread(
    String orderId,
  ) async {
    return _apiClient.get<OrderChatThreadModel>(
      ApiEndpoints.orderMessages(orderId),
      fromJson: (json) => OrderChatThreadModel.fromJson(json['data'] ?? {}),
    );
  }

  Future<ApiResult<SendMessageResultModel>> sendMessage({
    required String orderId,
    required String body,
  }) async {
    return _apiClient.post<SendMessageResultModel>(
      ApiEndpoints.orderMessages(orderId),
      body: {'body': body},
      fromJson: (json) => SendMessageResultModel.fromJson(json['data'] ?? {}),
    );
  }
}
