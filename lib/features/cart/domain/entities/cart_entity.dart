import 'package:equatable/equatable.dart';
import 'cart_item_entity.dart';

class CartEntity extends Equatable {
  final String id;
  final String restaurantId;
  final String restaurantName;
  final bool restaurantIsOpen;
  final List<CartItemEntity> items;
  final double itemTotal;
  final int itemCount;
  final double minOrderAmount;
  final bool meetsMinimum;

  const CartEntity({
    required this.id,
    required this.restaurantId,
    required this.restaurantName,
    required this.restaurantIsOpen,
    required this.items,
    required this.itemTotal,
    required this.itemCount,
    required this.minOrderAmount,
    required this.meetsMinimum,
  });

  @override
  List<Object?> get props => [
        id,
        restaurantId,
        restaurantName,
        restaurantIsOpen,
        items,
        itemTotal,
        itemCount,
        minOrderAmount,
        meetsMinimum,
      ];
}
