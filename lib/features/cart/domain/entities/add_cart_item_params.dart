import 'package:equatable/equatable.dart';

class CartAddOnParam extends Equatable {
  final String addOnId;
  final int quantity;

  const CartAddOnParam({
    required this.addOnId,
    this.quantity = 1,
  });

  Map<String, dynamic> toJson() => {
        'add_on_id': addOnId,
        'quantity': quantity,
      };

  @override
  List<Object?> get props => [addOnId, quantity];
}

class AddCartItemParams extends Equatable {
  final String menuItemId;
  final String? variantId;
  final List<String> addOnIds;
  final List<CartAddOnParam>? addOns;
  final int quantity;
  final String? mode;
  final String? notes;

  const AddCartItemParams({
    required this.menuItemId,
    this.variantId,
    this.addOnIds = const [],
    this.addOns,
    required this.quantity,
    this.mode,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'menu_item_id': menuItemId,
      if (variantId != null) 'variant_id': variantId,
      if (addOns != null && addOns!.isNotEmpty)
        'add_ons': addOns!.map((a) => a.toJson()).toList()
      else
        'add_on_ids': addOnIds,
      'quantity': quantity,
      if (mode != null) 'mode': mode,
      if (notes != null) 'notes': notes,
    };
  }

  @override
  List<Object?> get props => [
        menuItemId,
        variantId,
        addOnIds,
        addOns,
        quantity,
        mode,
        notes,
      ];
}
