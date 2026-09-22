import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
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
    on<AddOrUpdateCartItemEvent>(
      _onAddOrUpdateCartItem,
      transformer: (events, mapper) => events
          .groupBy((e) => e.params.menuItemId)
          .flatMap((group) => group.debounceTime(const Duration(milliseconds: 600)))
          .asyncExpand(mapper),
    );
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
          updatingItemIds: const {},
        ),
        onError: (error, _) => state.copyWith(
          status: CartStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        status: CartStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onAddOrUpdateCartItem(
      AddOrUpdateCartItemEvent event,
      Emitter<CartState> emit,
      ) async {
    final itemId = event.params.menuItemId;
    emit(state.copyWith(
      updatingItemIds: {...state.updatingItemIds, itemId},
      clearError: true,
    ));
    try {
      final updatedCart = await _addCartItemUseCase(event.params);
      emit(state.copyWith(
        cart: updatedCart,
        updatingItemIds: Set.from(state.updatingItemIds)..remove(itemId),
      ));
    } catch (e) {
      emit(state.copyWith(
        updatingItemIds: Set.from(state.updatingItemIds)..remove(itemId),
        errorMessage: e.toString(),
      ));
    }
  }
}