import '../entities/create_order_params.dart';
import '../entities/order_detail_entity.dart';
import '../repositories/i_orders_repository.dart';

class CreateOrderUseCase {
  final IOrdersRepository _repository;

  CreateOrderUseCase(this._repository);

  Future<OrderDetailEntity> call(CreateOrderParams params) {
    return _repository.createOrder(params);
  }
}
