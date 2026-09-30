import 'package:cheering/features/orders/domain/entities/create_order_params.dart';
import 'package:cheering/features/orders/domain/entities/get_orders_params.dart';
import 'package:cheering/features/orders/domain/entities/order_detail_entity.dart';
import 'package:cheering/features/orders/domain/entities/order_entity.dart';
import 'package:cheering/features/orders/domain/entities/submit_review_params.dart';

abstract class IOrdersRepository {
  Future<OrderDetailEntity> createOrder(CreateOrderParams params);

  Stream<List<OrderEntity>> getOrders(GetOrdersParams params);

  Future<OrderDetailEntity> getOrderDetails(String orderId);

  Future<void> cancelOrder(String orderId, String reason);

  Future<void> submitReview(SubmitReviewParams params);
}
