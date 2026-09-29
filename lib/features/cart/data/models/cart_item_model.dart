import '../../domain/entities/cart_item_entity.dart';
import 'cart_add_on_model.dart';

class CartItemModel extends CartItemEntity {
  const CartItemModel({
    super.id,
    super.lineId,
    required super.menuItemId,
    required super.name,
    super.imageUrl,
    required super.quantity,
    super.variantId,
    super.variantName,
    super.addOnIds = const [],
    super.addOnNames = const [],
    super.addOns = const [],
    required super.unitPrice,
    required super.addOnsTotal,
    required super.lineTotal,
    super.notes,
    required super.isAvailable,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final parsedAddOns = (json['add_ons'] as List<dynamic>?)
            ?.map((e) => CartAddOnModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    final rawAddOnIds = (json['add_on_ids'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [];

    final rawAddOnNames = (json['add_on_names'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [];

    return CartItemModel(
      lineId: (json['id'] ?? json['line_id'] ?? '') as String,
      menuItemId: (json['menu_item_id'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      imageUrl: json['image_url'] as String?,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      variantId: json['variant_id'] as String?,
      variantName: json['variant_name'] as String?,
      addOnIds: rawAddOnIds.isNotEmpty
          ? rawAddOnIds
          : parsedAddOns.map((a) => a.id).toList(),
      addOnNames: rawAddOnNames.isNotEmpty
          ? rawAddOnNames
          : parsedAddOns.map((a) => a.name).toList(),
      addOns: parsedAddOns,
      unitPrice: (json['unit_price'] as num?)?.toDouble() ?? 0.0,
      addOnsTotal: (json['add_ons_total'] as num?)?.toDouble() ?? 0.0,
      lineTotal: (json['line_total'] as num?)?.toDouble() ?? 0.0,
      notes: json['notes'] as String?,
      isAvailable: json['is_available'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': lineId,
      'menu_item_id': menuItemId,
      'name': name,
      'image_url': imageUrl,
      'quantity': quantity,
      'variant_id': variantId,
      'variant_name': variantName,
      'add_on_ids': addOnIds,
      'add_on_names': addOnNames,
      'add_ons': addOns
          .map((e) => (e is CartAddOnModel
                  ? e
                  : CartAddOnModel(
                      id: e.id,
                      name: e.name,
                      unitPrice: e.unitPrice,
                      quantity: e.quantity,
                    ))
              .toJson())
          .toList(),
      'unit_price': unitPrice,
      'add_ons_total': addOnsTotal,
      'line_total': lineTotal,
      'notes': notes,
      'is_available': isAvailable,
    };
  }
}
