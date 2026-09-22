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

  CartItemEntity copyWith({
    String? id,
    String? menuItemId,
    String? name,
    String? imageUrl,
    int? quantity,
    String? variantId,
    String? variantName,
    List<String>? addOnIds,
    List<String>? addOnNames,
    double? unitPrice,
    double? addOnsTotal,
    double? lineTotal,
    String? notes,
    bool? isAvailable,
  }) {
    return CartItemEntity(
      id: id ?? this.id,
      menuItemId: menuItemId ?? this.menuItemId,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
      variantId: variantId ?? this.variantId,
      variantName: variantName ?? this.variantName,
      addOnIds: addOnIds ?? this.addOnIds,
      addOnNames: addOnNames ?? this.addOnNames,
      unitPrice: unitPrice ?? this.unitPrice,
      addOnsTotal: addOnsTotal ?? this.addOnsTotal,
      lineTotal: lineTotal ?? this.lineTotal,
      notes: notes ?? this.notes,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

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
