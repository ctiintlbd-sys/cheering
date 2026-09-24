import 'package:equatable/equatable.dart';
import 'package:cheering/features/food/domain/entities/menu_entity.dart';

class ItemDetailsState extends Equatable {
  final MenuItemEntity menuItem;
  final MenuVariantEntity? selectedVariant;
  final List<MenuAddOnEntity> selectedAddOns;

  const ItemDetailsState({
    required this.menuItem,
    this.selectedVariant,
    this.selectedAddOns = const [],
  });

  double get unitPrice {
    double price = selectedVariant != null ? selectedVariant!.price : menuItem.basePrice;
    for (var addon in selectedAddOns) {
      price += addon.price;
    }
    return price;
  }

  @override
  List<Object?> get props => [menuItem, selectedVariant, selectedAddOns];
}
