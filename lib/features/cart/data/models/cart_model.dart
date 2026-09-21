import '../../domain/entities/cart_entity.dart';
import 'cart_item_model.dart';

class CartModel extends CartEntity {
  const CartModel({
    required super.id,
    required super.restaurantId,
    required super.restaurantName,
    required super.restaurantIsOpen,
    required super.items,
    required super.itemTotal,
    required super.itemCount,
    required super.minOrderAmount,
    required super.meetsMinimum,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'] as String,
      restaurantId: json['restaurant_id'] as String,
      restaurantName: json['restaurant_name'] as String,
      restaurantIsOpen: json['restaurant_is_open'] as bool? ?? false,
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      itemTotal: (json['item_total'] as num).toDouble(),
      itemCount: json['item_count'] as int? ?? 0,
      minOrderAmount: (json['min_order_amount'] as num).toDouble(),
      meetsMinimum: json['meets_minimum'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurant_id': restaurantId,
      'restaurant_name': restaurantName,
      'restaurant_is_open': restaurantIsOpen,
      'items': items.map((e) => (e as CartItemModel).toJson()).toList(),
      'item_total': itemTotal,
      'item_count': itemCount,
      'min_order_amount': minOrderAmount,
      'meets_minimum': meetsMinimum,
    };
  }
}
