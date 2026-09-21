import '../entities/add_cart_item_params.dart';
import '../entities/cart_entity.dart';
import '../repositories/i_cart_repository.dart';

class AddCartItemUseCase {
  final ICartRepository _repository;

  AddCartItemUseCase(this._repository);

  Future<CartEntity> call(AddCartItemParams params) {
    return _repository.addOrUpdateCartItem(params);
  }
}
