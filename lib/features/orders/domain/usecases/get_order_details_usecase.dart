import '../entities/order_detail_entity.dart';
import '../repositories/i_orders_repository.dart';

class GetOrderDetailsUseCase {
  final IOrdersRepository _repository;

  GetOrderDetailsUseCase(this._repository);

  Future<OrderDetailEntity> call(String orderId) {
    return _repository.getOrderDetails(orderId);
  }
}
