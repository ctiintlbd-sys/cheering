import '../../../../core/config/api_endpoints.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/i_api_client.dart';
import '../../domain/entities/create_order_params.dart';
import '../../domain/entities/get_orders_params.dart';
import '../../domain/entities/submit_review_params.dart';
import '../models/order_model.dart';
import '../models/order_detail_model.dart';
import 'package:uuid/uuid.dart';

class OrdersRemoteSource {
  final IApiClient _apiClient;
  final Uuid _uuid = const Uuid();

  OrdersRemoteSource(this._apiClient);

  Future<ApiResult<OrderDetailModel>> createOrder(
    CreateOrderParams params,
  ) async {
    final idempotencyKey = _uuid.v4();
    return _apiClient.post<OrderDetailModel>(
      ApiEndpoints.orders,
      body: params.toMap(),
      headers: {'Idempotency-Key': idempotencyKey},
      fromJson: (json) => OrderDetailModel.fromJson(json['data'] ?? {}),
      requiresAuth: true,
    );
  }

  Future<ApiResult<List<OrderModel>>> getOrders(GetOrdersParams params) async {
    return _apiClient.get<List<OrderModel>>(
      ApiEndpoints.orders,
      queryParameters: params.toMap(),
      fromJson: (json) {
        final data = json['data'] as List<dynamic>? ?? [];
        return data
            .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
      requiresAuth: true,
    );
  }

  Future<ApiResult<OrderDetailModel>> getOrderDetails(String orderId) async {
    return _apiClient.get<OrderDetailModel>(
      ApiEndpoints.orderDetails(orderId),
      fromJson: (json) => OrderDetailModel.fromJson(json['data'] ?? {}),
      requiresAuth: true,
    );
  }

  Future<ApiResult<void>> cancelOrder(String orderId, String reason) async {
    return _apiClient.post<void>(
      ApiEndpoints.cancelOrder(orderId),
      body: {'reason': reason},
      fromJson: (_) {},
      requiresAuth: true,
    );
  }

  Future<ApiResult<void>> submitReview(SubmitReviewParams params) async {
    return _apiClient.post<void>(
      ApiEndpoints.orderReviews(params.orderId),
      body: params.toMap(),
      fromJson: (_) {},
      requiresAuth: true,
    );
  }
}
