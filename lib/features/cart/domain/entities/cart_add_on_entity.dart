import 'package:equatable/equatable.dart';

class CartAddOnEntity extends Equatable {
  final String id;
  final String name;
  final double unitPrice;
  final int quantity;

  const CartAddOnEntity({
    required this.id,
    required this.name,
    required this.unitPrice,
    required this.quantity,
  });

  CartAddOnEntity copyWith({
    String? id,
    String? name,
    double? unitPrice,
    int? quantity,
  }) {
    return CartAddOnEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [id, name, unitPrice, quantity];
}
