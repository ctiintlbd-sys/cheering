import '../repositories/i_orders_repository.dart';

class CancelOrderUseCase {
  final IOrdersRepository _repository;

  CancelOrderUseCase(this._repository);

  Future<void> call(String orderId, String reason) {
    return _repository.cancelOrder(orderId, reason);
  }
}
