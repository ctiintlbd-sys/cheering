import '../entities/get_orders_params.dart';
import '../entities/order_entity.dart';
import '../repositories/i_orders_repository.dart';

class GetOrdersUseCase {
  final IOrdersRepository _repository;

  GetOrdersUseCase(this._repository);

  Stream<List<OrderEntity>> call(GetOrdersParams params) {
    return _repository.getOrders(params);
  }
}
