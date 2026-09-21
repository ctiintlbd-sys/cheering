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
        ),
        onError: (error, _) => state.copyWith(
          status: CartStatus.failure,
          errorMessage: error.toString(),
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
    // We only show isUpdating so we don't clear the whole cart UI while syncing
    emit(state.copyWith(isUpdating: true, clearError: true));

    try {
      // Calling this updates the cache in the repository,
      // which automatically triggers the stream in _onLoadCart to emit the new cart.
      await _addCartItemUseCase(event.params);
      emit(state.copyWith(isUpdating: false));
    } catch (e) {
      emit(
        state.copyWith(
          isUpdating: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
