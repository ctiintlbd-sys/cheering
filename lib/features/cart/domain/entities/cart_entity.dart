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

  int quantityFor(String menuItemId) =>
      items
          .where((i) => i.menuItemId == menuItemId)
          .fold(0, (sum, i) => sum + i.quantity);

  CartEntity withUpdatedQuantity(String menuItemId, String? variantId, int quantity) {
    final itemIndex = items.indexWhere((i) => i.menuItemId == menuItemId);
    if (itemIndex == -1) return this;

    final updatedItems = List<CartItemEntity>.from(items);
    final i = updatedItems[itemIndex];
    
    if (quantity <= 0) {
      updatedItems.removeAt(itemIndex);
    } else {
      final perUnitAddon = i.quantity > 0 ? (i.addOnsTotal / i.quantity) : 0.0;
      final newAddOnsTotal = perUnitAddon * quantity;
      final newLineTotal = (i.unitPrice * quantity) + newAddOnsTotal;

      updatedItems[itemIndex] = i.copyWith(
        quantity: quantity,
        addOnsTotal: newAddOnsTotal,
        lineTotal: newLineTotal,
      );
    }

    final newItemTotal = updatedItems.fold(0.0, (sum, item) => sum + item.lineTotal);
    final newItemCount = updatedItems.fold(0, (sum, item) => sum + item.quantity);

    return copyWith(
      items: updatedItems,
      itemTotal: newItemTotal,
      itemCount: newItemCount,
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
