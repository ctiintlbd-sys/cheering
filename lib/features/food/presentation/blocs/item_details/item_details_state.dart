import 'package:equatable/equatable.dart';
import 'package:cheering/features/food/domain/entities/menu_entity.dart';

class ItemDetailsState extends Equatable {
  final MenuItemEntity menuItem;
  final MenuVariantEntity? selectedVariant;
  final List<MenuAddOnEntity> selectedAddOns;
  final int quantity;

  const ItemDetailsState({
    required this.menuItem,
    this.selectedVariant,
    this.selectedAddOns = const [],
    this.quantity = 1,
  });

  double get totalPrice {
    double price = selectedVariant != null ? selectedVariant!.price : menuItem.basePrice;
    for (var addon in selectedAddOns) {
      price += addon.price;
    }
    return price * quantity;
  }

  @override
  List<Object?> get props => [menuItem, selectedVariant, selectedAddOns, quantity];
}
