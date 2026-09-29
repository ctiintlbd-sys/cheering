import 'package:equatable/equatable.dart';
import 'cart_add_on_entity.dart';

class CartItemEntity extends Equatable {
  final String lineId;
  String get id => lineId;
  final String menuItemId;
  final String name;
  final String? imageUrl;
  final int quantity;
  final String? variantId;
  final String? variantName;
  final List<String> addOnIds;
  final List<String> addOnNames;
  final List<CartAddOnEntity> addOns;
  final double unitPrice;
  final double addOnsTotal;
  final double lineTotal;
  final String? notes;
  final bool isAvailable;

  const CartItemEntity({
    String? id,
    String? lineId,
    required this.menuItemId,
    required this.name,
    this.imageUrl,
    required this.quantity,
    this.variantId,
    this.variantName,
    this.addOnIds = const [],
    this.addOnNames = const [],
    this.addOns = const [],
    required this.unitPrice,
    required this.addOnsTotal,
    required this.lineTotal,
    this.notes,
    required this.isAvailable,
  }) : lineId = lineId ?? id ?? '';

  CartItemEntity copyWith({
    String? id,
    String? lineId,
    String? menuItemId,
    String? name,
    String? imageUrl,
    int? quantity,
    String? variantId,
    String? variantName,
    List<String>? addOnIds,
    List<String>? addOnNames,
    List<CartAddOnEntity>? addOns,
    double? unitPrice,
    double? addOnsTotal,
    double? lineTotal,
    String? notes,
    bool? isAvailable,
  }) {
    return CartItemEntity(
      lineId: lineId ?? id ?? this.lineId,
      menuItemId: menuItemId ?? this.menuItemId,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
      variantId: variantId ?? this.variantId,
      variantName: variantName ?? this.variantName,
      addOnIds: addOnIds ?? this.addOnIds,
      addOnNames: addOnNames ?? this.addOnNames,
      addOns: addOns ?? this.addOns,
      unitPrice: unitPrice ?? this.unitPrice,
      addOnsTotal: addOnsTotal ?? this.addOnsTotal,
      lineTotal: lineTotal ?? this.lineTotal,
      notes: notes ?? this.notes,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  @override
  List<Object?> get props => [
        lineId,
        menuItemId,
        name,
        imageUrl,
        quantity,
        variantId,
        variantName,
        addOnIds,
        addOnNames,
        addOns,
        unitPrice,
        addOnsTotal,
        lineTotal,
        notes,
        isAvailable,
      ];
}
