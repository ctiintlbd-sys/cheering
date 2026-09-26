import '../entities/order_tracking_entity.dart';

abstract class ITrackingRepository {
  Future<OrderTrackingEntity> getOrderTracking(String orderId);
}
