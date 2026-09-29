import '../entities/cart_entity.dart';
import '../repositories/i_cart_repository.dart';

class RemoveCartItemUseCase {
  final ICartRepository _repository;

  RemoveCartItemUseCase(this._repository);

  Future<CartEntity> call(String lineId) {
    return _repository.removeCartItem(lineId);
  }
}
