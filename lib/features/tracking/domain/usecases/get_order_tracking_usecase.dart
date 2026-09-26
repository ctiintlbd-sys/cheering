import '../entities/order_tracking_entity.dart';
import '../repositories/i_tracking_repository.dart';

class GetOrderTrackingUseCase {
  final ITrackingRepository _repository;

  GetOrderTrackingUseCase(this._repository);

  Future<OrderTrackingEntity> call(String orderId) {
    return _repository.getOrderTracking(orderId);
  }
}
