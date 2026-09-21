import '../../domain/entities/cart_item_entity.dart';

class CartItemModel extends CartItemEntity {
  const CartItemModel({
    required super.id,
    required super.menuItemId,
    required super.name,
    super.imageUrl,
    required super.quantity,
    super.variantId,
    super.variantName,
    required super.addOnIds,
    required super.addOnNames,
    required super.unitPrice,
    required super.addOnsTotal,
    required super.lineTotal,
    super.notes,
    required super.isAvailable,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] as String,
      menuItemId: json['menu_item_id'] as String,
      name: json['name'] as String,
      imageUrl: json['image_url'] as String?,
      quantity: json['quantity'] as int,
      variantId: json['variant_id'] as String?,
      variantName: json['variant_name'] as String?,
      addOnIds:
          (json['add_on_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      addOnNames:
          (json['add_on_names'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      unitPrice: (json['unit_price'] as num).toDouble(),
      addOnsTotal: (json['add_ons_total'] as num).toDouble(),
      lineTotal: (json['line_total'] as num).toDouble(),
      notes: json['notes'] as String?,
      isAvailable: json['is_available'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'menu_item_id': menuItemId,
      'name': name,
      'image_url': imageUrl,
      'quantity': quantity,
      'variant_id': variantId,
      'variant_name': variantName,
      'add_on_ids': addOnIds,
      'add_on_names': addOnNames,
      'unit_price': unitPrice,
      'add_ons_total': addOnsTotal,
      'line_total': lineTotal,
      'notes': notes,
      'is_available': isAvailable,
    };
  }
}
