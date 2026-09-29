import '../../domain/entities/cart_add_on_entity.dart';

class CartAddOnModel extends CartAddOnEntity {
  const CartAddOnModel({
    required super.id,
    required super.name,
    required super.unitPrice,
    required super.quantity,
  });

  factory CartAddOnModel.fromJson(Map<String, dynamic> json) {
    return CartAddOnModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      unitPrice: (json['unit_price'] as num?)?.toDouble() ?? 0.0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'unit_price': unitPrice,
      'quantity': quantity,
    };
  }
}
