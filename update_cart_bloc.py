import os

bloc_dir = "lib/features/cart/presentation/blocs/cart"
cart_bloc_path = os.path.join(bloc_dir, "cart_bloc.dart")

with open(cart_bloc_path, 'w') as f:
    f.write('''import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import '../../../domain/entities/cart_entity.dart';
import '../../../domain/entities/cart_item_entity.dart';
import '../../../domain/usecases/get_cart_usecase.dart';
import '../../../domain/usecases/add_cart_item_usecase.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartUseCase _getCartUseCase;
  final AddCartItemUseCase _addCartItemUseCase;

  CartBloc(this._getCartUseCase, this._addCartItemUseCase)
      : super(const CartState()) {
    on<LoadCart>(
      _onLoadCart,
      transformer: restartable(),
    );
    on<AddOrUpdateCartItemEvent>(_onAddOrUpdateCartItem);
    
    on<SyncCartApiEvent>(
      _onSyncCartApi,
      transformer: (events, mapper) =>
          events.debounceTime(const Duration(milliseconds: 600)).switchMap(mapper),
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
          isUpdating: false,
        ),
        onError: (error, _) => state.copyWith(
          status: CartStatus.failure,
          errorMessage: error.toString(),
          isUpdating: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        status: CartStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onAddOrUpdateCartItem(
    AddOrUpdateCartItemEvent event,
    Emitter<CartState> emit,
  ) {
    if (state.cart == null) {
      add(SyncCartApiEvent(event.params));
      return;
    }

    final params = event.params;
    final currentCart = state.cart!;
    final currentItems = List<CartItemEntity>.from(currentCart.items);

    final itemIndex = currentItems.indexWhere((item) =>
        item.menuItemId == params.menuItemId &&
        item.variantId == params.variantId);

    if (itemIndex != -1) {
      final item = currentItems[itemIndex];
      if (params.quantity <= 0) {
        currentItems.removeAt(itemIndex);
      } else {
        currentItems[itemIndex] = item.copyWith(
          quantity: params.quantity,
          lineTotal: (item.unitPrice * params.quantity) + item.addOnsTotal,
          notes: params.notes ?? item.notes,
        );
      }
    }
    // Note: No optimistic update for brand new items since price isn't locally known

    double newItemTotal = 0.0;
    int newItemCount = 0;
    for (var it in currentItems) {
      newItemTotal += it.lineTotal;
      newItemCount += it.quantity;
    }

    emit(state.copyWith(
      cart: currentCart.copyWith(
        items: currentItems,
        itemTotal: newItemTotal,
        itemCount: newItemCount,
      ),
      isUpdating: true,
      clearError: true,
    ));

    add(SyncCartApiEvent(event.params));
  }

  Future<void> _onSyncCartApi(
    SyncCartApiEvent event,
    Emitter<CartState> emit,
  ) async {
    final previousCart = state.cart;
    
    try {
      await _addCartItemUseCase(event.params);
    } catch (e) {
      emit(state.copyWith(
        cart: previousCart,
        errorMessage: 'Failed to update cart: ${e.toString()}',
        isUpdating: false,
      ));
    }
  }
}
''')

print("CartBloc rewritten successfully!")
