import 'package:equatable/equatable.dart';
import '../../../domain/entities/cart_entity.dart';

enum CartStatus { initial, loading, success, failure }

class CartState extends Equatable {
  final CartStatus status;
  final CartEntity? cart;
  final String? errorMessage;
  final bool isUpdating;

  const CartState({
    this.status = CartStatus.initial,
    this.cart,
    this.errorMessage,
    this.isUpdating = false,
  });

  CartState copyWith({
    CartStatus? status,
    CartEntity? cart,
    String? errorMessage,
    bool? isUpdating,
    bool clearError = false,
  }) {
    return CartState(
      status: status ?? this.status,
      cart: cart ?? this.cart,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isUpdating: isUpdating ?? this.isUpdating,
    );
  }

  @override
  List<Object?> get props => [status, cart, errorMessage, isUpdating];
}
