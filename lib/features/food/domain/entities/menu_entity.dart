import 'package:equatable/equatable.dart';

class MenuVariantEntity extends Equatable {
  final String id;
  final String name;
  final double price;
  final bool isDefault;
  final bool isAvailable;

  const MenuVariantEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.isDefault,
    required this.isAvailable,
  });

  @override
  List<Object?> get props => [id, name, price, isDefault, isAvailable];
}

class MenuAddOnEntity extends Equatable {
  final String id;
  final String name;
  final double price;
  final bool isAvailable;

  const MenuAddOnEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.isAvailable,
  });

  @override
  List<Object?> get props => [id, name, price, isAvailable];
}

class MenuItemEntity extends Equatable {
  final String id;
  final String? categoryId;
  final String name;
  final String? description;
  final double basePrice;
  final String? imageUrl;
  final bool isAvailable;
  final bool? isVeg;
  final int? prepTimeMins;
  final List<MenuVariantEntity>? variants;
  final List<MenuAddOnEntity>? addOns;

  // For search results where restaurant details might be attached
  final String? restaurantId;
  final String? restaurantName;

  const MenuItemEntity({
    required this.id,
    this.categoryId,
    required this.name,
    this.description,
    required this.basePrice,
    this.imageUrl,
    required this.isAvailable,
    this.isVeg,
    this.prepTimeMins,
    this.variants,
    this.addOns,
    this.restaurantId,
    this.restaurantName,
  });

  @override
  List<Object?> get props => [
    id,
    categoryId,
    name,
    description,
    basePrice,
    imageUrl,
    isAvailable,
    isVeg,
    prepTimeMins,
    variants,
    addOns,
    restaurantId,
    restaurantName,
  ];
}

class MenuCategoryEntity extends Equatable {
  final String id;
  final String name;
  final int sortOrder;
  final List<MenuItemEntity> items;

  const MenuCategoryEntity({
    required this.id,
    required this.name,
    required this.sortOrder,
    required this.items,
  });

  @override
  List<Object?> get props => [id, name, sortOrder, items];
}
