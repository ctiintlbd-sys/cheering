import 'package:equatable/equatable.dart';
import '../../../domain/entities/add_cart_item_params.dart';

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

class SyncCartItemEvent extends CartEvent {
  final AddCartItemParams params;

  const SyncCartItemEvent(this.params);

  @override
  List<Object?> get props => [params];
}