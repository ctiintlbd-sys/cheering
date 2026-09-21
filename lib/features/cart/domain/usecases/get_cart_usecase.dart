import '../entities/cart_entity.dart';
import '../repositories/i_cart_repository.dart';

class GetCartUseCase {
  final ICartRepository _repository;

  GetCartUseCase(this._repository);

  Stream<CartEntity> call() {
    return _repository.getCart();
  }
}
