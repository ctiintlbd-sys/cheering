import '../../../../core/config/api_endpoints.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/i_api_client.dart';
import '../models/order_tracking_model.dart';

class TrackingRemoteSource {
  final IApiClient _apiClient;

  TrackingRemoteSource(this._apiClient);

  Future<ApiResult<OrderTrackingModel>> getOrderTracking(String orderId) {
    return _apiClient.get<OrderTrackingModel>(
      ApiEndpoints.orderTracking(orderId),
      fromJson: (json) =>
          OrderTrackingModel.fromJson(json['data'] ?? {}),
      requiresAuth: true,
    );
  }
}
