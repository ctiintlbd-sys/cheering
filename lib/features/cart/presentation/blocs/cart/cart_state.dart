import 'package:equatable/equatable.dart';
import '../../../domain/entities/cart_entity.dart';

enum CartStatus { initial, loading, success, failure }

class CartState extends Equatable {
  final CartStatus status;
  final CartEntity? cart;
  final String? errorMessage;
  final Set<String> updatingItemIds;

  const CartState({
    this.status = CartStatus.initial,
    this.cart,
    this.errorMessage,
    this.updatingItemIds = const {},
  });

  bool isItemUpdating(String menuItemId) =>
      updatingItemIds.contains(menuItemId);

  CartState copyWith({
    CartStatus? status,
    CartEntity? cart,
    String? errorMessage,
    Set<String>? updatingItemIds,
    bool clearError = false,
  }) {
    return CartState(
      status: status ?? this.status,
      cart: cart ?? this.cart,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      updatingItemIds: updatingItemIds ?? this.updatingItemIds,
    );
  }

  @override
  List<Object?> get props => [status, cart, errorMessage, updatingItemIds];
}