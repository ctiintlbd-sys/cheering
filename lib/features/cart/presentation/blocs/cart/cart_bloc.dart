import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/cart_entity.dart';
import '../../../domain/usecases/get_cart_usecase.dart';
import '../../../domain/usecases/add_cart_item_usecase.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartUseCase _getCartUseCase;
  final AddCartItemUseCase _addCartItemUseCase;

  CartBloc(this._getCartUseCase, this._addCartItemUseCase)
      : super(const CartState()) {
    on<LoadCart>(_onLoadCart);
    on<AddOrUpdateCartItemEvent>(_onAddOrUpdateCartItem);
  }

  Future<void> _onLoadCart(
    LoadCart event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(status: CartStatus.loading, clearError: true));

    try {
      await emit.forEach<CartEntity>(
        _getCartUseCase(),
        onData: (cart) => state.copyWith(
          status: CartStatus.success,
          cart: cart,
          clearError: true,
          isUpdating: false,
        ),
        onError: (error, _) => state.copyWith(
          status: CartStatus.failure,
          errorMessage: error.toString(),
          isUpdating: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CartStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onAddOrUpdateCartItem(
    AddOrUpdateCartItemEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(isUpdating: true));
    try {
      await _addCartItemUseCase(event.params);
      // The use case internally updates the cache on success,
      // which automatically pushes the new cart through emit.forEach.
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Failed to update item: ${e.toString()}',
        isUpdating: false,
      ));
    }
  }
}
