import 'package:equatable/equatable.dart';
import 'cart_item_entity.dart';

class CartEntity extends Equatable {
  final String? id;
  final String? restaurantId;
  final String? restaurantName;
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

  CartEntity copyWith({
    String? id,
    String? restaurantId,
    String? restaurantName,
    bool? restaurantIsOpen,
    List<CartItemEntity>? items,
    double? itemTotal,
    int? itemCount,
    double? minOrderAmount,
    bool? meetsMinimum,
  }) {
    return CartEntity(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      restaurantIsOpen: restaurantIsOpen ?? this.restaurantIsOpen,
      items: items ?? this.items,
      itemTotal: itemTotal ?? this.itemTotal,
      itemCount: itemCount ?? this.itemCount,
      minOrderAmount: minOrderAmount ?? this.minOrderAmount,
      meetsMinimum: meetsMinimum ?? this.meetsMinimum,
    );
  }

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
