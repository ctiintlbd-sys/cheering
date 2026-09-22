import os

bloc_dir = "lib/features/cart/presentation/blocs/cart"
cart_bloc_path = os.path.join(bloc_dir, "cart_bloc.dart")

with open(cart_bloc_path, 'r') as f:
    content = f.read()

# Add _lastKnownRealCart
content = content.replace(
    '  final AddCartItemUseCase _addCartItemUseCase;',
    '  final AddCartItemUseCase _addCartItemUseCase;\n\n  CartEntity? _lastKnownRealCart;'
)

# Update onData in emit.forEach
content = content.replace(
    '''        onData: (cart) => state.copyWith(
          status: CartStatus.success,
          cart: cart,
          clearError: true,
          isUpdating: false,
        ),''',
    '''        onData: (cart) {
          _lastKnownRealCart = cart;
          return state.copyWith(
            status: CartStatus.success,
            cart: cart,
            clearError: true,
            isUpdating: false,
          );
        },'''
)

# Fix _onSyncCartApi
content = content.replace(
    '''  Future<void> _onSyncCartApi(
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
  }''',
    '''  Future<void> _onSyncCartApi(
    SyncCartApiEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      await _addCartItemUseCase(event.params);
    } catch (e) {
      emit(state.copyWith(
        cart: _lastKnownRealCart,
        errorMessage: 'Failed to update cart: ${e.toString()}',
        isUpdating: false,
      ));
    }
  }'''
)

with open(cart_bloc_path, 'w') as f:
    f.write(content)

print("Rollback logic fixed!")
