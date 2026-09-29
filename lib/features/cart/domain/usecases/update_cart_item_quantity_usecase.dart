import '../entities/cart_entity.dart';
import '../repositories/i_cart_repository.dart';

class UpdateCartItemQuantityUseCase {
  final ICartRepository _repository;

  UpdateCartItemQuantityUseCase(this._repository);

  Future<CartEntity> call({
    required String lineId,
    required int quantity,
    String? notes,
  }) {
    return _repository.updateCartItemQuantity(
      lineId: lineId,
      quantity: quantity,
      notes: notes,
    );
  }
}
