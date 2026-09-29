import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/add_cart_item_params.dart';
import '../../../domain/entities/cart_entity.dart';
import '../../../domain/usecases/get_cart_usecase.dart';
import '../../../domain/usecases/add_cart_item_usecase.dart';
import '../../../domain/usecases/update_cart_item_quantity_usecase.dart';
import '../../../domain/usecases/remove_cart_item_usecase.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartUseCase _getCartUseCase;
  final AddCartItemUseCase _addCartItemUseCase;
  final UpdateCartItemQuantityUseCase _updateCartItemQuantityUseCase;
  final RemoveCartItemUseCase _removeCartItemUseCase;

  CartBloc(
    this._getCartUseCase,
    this._addCartItemUseCase,
    this._updateCartItemQuantityUseCase,
    this._removeCartItemUseCase,
  ) : super(const CartState()) {
    on<LoadCart>(_onLoadCart);
    on<ClearCart>(_onClearCart);
    on<AddOrUpdateCartItemEvent>(_onAddOrUpdateCartItem);
    on<UpdateCartLineQuantityEvent>(_onUpdateCartLineQuantity);
    on<UpdateCartAddOnQuantityEvent>(_onUpdateCartAddOnQuantity);
    on<RemoveCartItemEvent>(_onRemoveCartItem);
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

  Future<void> _onAddOrUpdateCartItem(
    AddOrUpdateCartItemEvent event,
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
      emit(
        state.copyWith(
          status: CartStatus.success,
          cart: updatedCart,
          updatingItemIds: Set.from(state.updatingItemIds)..remove(itemId),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          updatingItemIds: Set.from(state.updatingItemIds)..remove(itemId),
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onUpdateCartLineQuantity(
    UpdateCartLineQuantityEvent event,
    Emitter<CartState> emit,
  ) async {
    final lineId = event.lineId;
    emit(
      state.copyWith(
        updatingItemIds: {...state.updatingItemIds, lineId},
        clearError: true,
      ),
    );
    try {
      final CartEntity updatedCart;
      if (event.quantity <= 0) {
        updatedCart = await _removeCartItemUseCase(lineId);
      } else {
        updatedCart = await _updateCartItemQuantityUseCase(
          lineId: lineId,
          quantity: event.quantity,
          notes: event.notes,
        );
      }
      emit(
        state.copyWith(
          status: CartStatus.success,
          cart: updatedCart,
          updatingItemIds: Set.from(state.updatingItemIds)..remove(lineId),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          updatingItemIds: Set.from(state.updatingItemIds)..remove(lineId),
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onUpdateCartAddOnQuantity(
    UpdateCartAddOnQuantityEvent event,
    Emitter<CartState> emit,
  ) async {
    final item = event.item;
    final lineId = item.lineId;
    emit(
      state.copyWith(
        updatingItemIds: {...state.updatingItemIds, lineId},
        clearError: true,
      ),
    );

    try {
      final updatedAddOns = <CartAddOnParam>[];
      for (final addOn in item.addOns) {
        if (addOn.id == event.addOnId) {
          if (event.quantity > 0) {
            updatedAddOns.add(
              CartAddOnParam(addOnId: addOn.id, quantity: event.quantity),
            );
          }
        } else {
          updatedAddOns.add(
            CartAddOnParam(addOnId: addOn.id, quantity: addOn.quantity),
          );
        }
      }

      final params = AddCartItemParams(
        menuItemId: item.menuItemId,
        variantId: item.variantId,
        quantity: item.quantity,
        mode: 'set',
        addOns: updatedAddOns,
        notes: item.notes,
      );

      final updatedCart = await _addCartItemUseCase(params);
      emit(
        state.copyWith(
          status: CartStatus.success,
          cart: updatedCart,
          updatingItemIds: Set.from(state.updatingItemIds)..remove(lineId),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          updatingItemIds: Set.from(state.updatingItemIds)..remove(lineId),
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onRemoveCartItem(
    RemoveCartItemEvent event,
    Emitter<CartState> emit,
  ) async {
    final lineId = event.lineId;
    emit(
      state.copyWith(
        updatingItemIds: {...state.updatingItemIds, lineId},
        clearError: true,
      ),
    );
    try {
      final updatedCart = await _removeCartItemUseCase(lineId);
      emit(
        state.copyWith(
          status: CartStatus.success,
          cart: updatedCart,
          updatingItemIds: Set.from(state.updatingItemIds)..remove(lineId),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          updatingItemIds: Set.from(state.updatingItemIds)..remove(lineId),
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
