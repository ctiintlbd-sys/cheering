import 'package:cheering/features/cart/domain/entities/cart_item_entity.dart';
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
    on<ClearCart>(_onClearCart);
    on<AddOrUpdateCartItemEvent>(_onAddOrUpdateCartItem);
    on<SyncCartItemEvent>(
      _onSyncCartItem,
      transformer: (events, mapper) => events
          .groupBy((e) => e.params.menuItemId)
          .flatMap(
            (group) => group.debounceTime(const Duration(milliseconds: 600)),
          )
          .asyncExpand(mapper),
    );
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    emit(const CartState());
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
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
        state.copyWith(status: CartStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  void _onAddOrUpdateCartItem(
    AddOrUpdateCartItemEvent event,
    Emitter<CartState> emit,
  ) {
    if (state.cart != null) {
      final newCart = state.cart!.withUpdatedQuantity(
        event.params.menuItemId,
        event.params.variantId,
        event.params.quantity,
      );
      emit(state.copyWith(cart: newCart));
    }

    add(SyncCartItemEvent(event.params));
  }

  Future<void> _onSyncCartItem(
    SyncCartItemEvent event,
    Emitter<CartState> emit,
  ) async {
    final itemId = event.params.menuItemId;
    emit(
      state.copyWith(
        updatingItemIds: {...state.updatingItemIds, itemId},
        clearError: true,
      ),
    );
    try {
      final updatedCart = await _addCartItemUseCase(event.params);

      final currentPending = Set<String>.from(state.updatingItemIds)
        ..remove(itemId);
      final finalCart = _mergeWithPending(updatedCart, currentPending);

      emit(state.copyWith(cart: finalCart, updatingItemIds: currentPending));
    } catch (e) {
      emit(
        state.copyWith(
          updatingItemIds: Set.from(state.updatingItemIds)..remove(itemId),
          errorMessage: e.toString(),
        ),
      );
    }
  }

  CartEntity _mergeWithPending(CartEntity apiCart, Set<String> pendingIds) {
    if (pendingIds.isEmpty) return apiCart;
    if (state.cart == null) return apiCart;

    final List<CartItemEntity> mergedItems = [];

    for (final apiItem in apiCart.items) {
      if (pendingIds.contains(apiItem.menuItemId)) {
        final localItem = state.cart!.items
            .where((i) => i.menuItemId == apiItem.menuItemId)
            .firstOrNull;

        if (localItem != null) {
          mergedItems.add(localItem);
        }
      } else {
        mergedItems.add(apiItem);
      }
    }

    final newItemTotal = mergedItems.fold(
      0.0,
      (sum, item) => sum + item.lineTotal,
    );
    final newItemCount = mergedItems.fold(
      0,
      (sum, item) => sum + item.quantity,
    );

    return apiCart.copyWith(
      items: mergedItems,
      itemTotal: newItemTotal,
      itemCount: newItemCount,
    );
  }
}
