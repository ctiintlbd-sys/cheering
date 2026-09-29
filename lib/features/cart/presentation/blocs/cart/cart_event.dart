import 'package:equatable/equatable.dart';
import '../../../domain/entities/add_cart_item_params.dart';
import '../../../domain/entities/cart_item_entity.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class LoadCart extends CartEvent {
  const LoadCart();
}

class ClearCart extends CartEvent {
  const ClearCart();
}

class AddOrUpdateCartItemEvent extends CartEvent {
  final AddCartItemParams params;

  const AddOrUpdateCartItemEvent(this.params);

  @override
  List<Object?> get props => [params];
}

class UpdateCartLineQuantityEvent extends CartEvent {
  final String lineId;
  final int quantity;
  final String? notes;

  const UpdateCartLineQuantityEvent({
    required this.lineId,
    required this.quantity,
    this.notes,
  });

  @override
  List<Object?> get props => [lineId, quantity, notes];
}

class UpdateCartAddOnQuantityEvent extends CartEvent {
  final CartItemEntity item;
  final String addOnId;
  final int quantity;

  const UpdateCartAddOnQuantityEvent({
    required this.item,
    required this.addOnId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [item, addOnId, quantity];
}

class RemoveCartItemEvent extends CartEvent {
  final String lineId;

  const RemoveCartItemEvent({required this.lineId});

  @override
  List<Object?> get props => [lineId];
}