import 'package:equatable/equatable.dart';

class AddCartItemParams extends Equatable {
  final String menuItemId;
  final String? variantId;
  final List<String> addOnIds;
  final int quantity;
  final String? notes;

  const AddCartItemParams({
    required this.menuItemId,
    this.variantId,
    this.addOnIds = const [],
    required this.quantity,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'menu_item_id': menuItemId,
      if (variantId != null) 'variant_id': variantId,
      'add_on_ids': addOnIds,
      'quantity': quantity,
      if (notes != null) 'notes': notes,
    };
  }

  @override
  List<Object?> get props => [menuItemId, variantId, addOnIds, quantity, notes];
}
