import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  final String id;
  final String menuItemId;
  final String name;
  final String? imageUrl;
  final int quantity;
  final String? variantId;
  final String? variantName;
  final List<String> addOnIds;
  final List<String> addOnNames;
  final double unitPrice;
  final double addOnsTotal;
  final double lineTotal;
  final String? notes;
  final bool isAvailable;

  const CartItemEntity({
    required this.id,
    required this.menuItemId,
    required this.name,
    this.imageUrl,
    required this.quantity,
    this.variantId,
    this.variantName,
    required this.addOnIds,
    required this.addOnNames,
    required this.unitPrice,
    required this.addOnsTotal,
    required this.lineTotal,
    this.notes,
    required this.isAvailable,
  });

  @override
  List<Object?> get props => [
        id,
        menuItemId,
        name,
        imageUrl,
        quantity,
        variantId,
        variantName,
        addOnIds,
        addOnNames,
        unitPrice,
        addOnsTotal,
        lineTotal,
        notes,
        isAvailable,
      ];
}
