import '../../domain/entities/menu_entity.dart';

class MenuVariantModel extends MenuVariantEntity {
  const MenuVariantModel({
    required super.id,
    required super.name,
    required super.price,
    required super.isDefault,
    required super.isAvailable,
  });

  factory MenuVariantModel.fromJson(Map<String, dynamic> json) {
    return MenuVariantModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      isDefault: json['is_default'] == true,
      isAvailable: json['is_available'] == true,
    );
  }
}

class MenuAddOnModel extends MenuAddOnEntity {
  const MenuAddOnModel({
    required super.id,
    required super.name,
    required super.price,
    required super.isAvailable,
  });

  factory MenuAddOnModel.fromJson(Map<String, dynamic> json) {
    return MenuAddOnModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      isAvailable: json['is_available'] == true,
    );
  }
}

class MenuItemModel extends MenuItemEntity {
  const MenuItemModel({
    required super.id,
    super.categoryId,
    required super.name,
    super.description,
    required super.basePrice,
    super.imageUrl,
    required super.isAvailable,
    super.isVeg,
    super.prepTimeMins,
    super.variants,
    super.addOns,
    super.restaurantId,
    super.restaurantName,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['id'] as String? ?? '',
      categoryId: json['category_id'] as String?,
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      basePrice: (json['base_price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['image_url'] as String?,
      isAvailable: json['is_available'] == true,
      isVeg: json['is_veg'] as bool?,
      prepTimeMins: json['prep_time_mins'] as int?,
      variants: (json['variants'] as List<dynamic>?)
          ?.map((e) => MenuVariantModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      addOns: (json['add_ons'] as List<dynamic>?)
          ?.map((e) => MenuAddOnModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      restaurantId: json['restaurant_id'] as String?,
      restaurantName: json['restaurant_name'] as String?,
    );
  }
}

class MenuCategoryModel extends MenuCategoryEntity {
  const MenuCategoryModel({
    required super.id,
    required super.name,
    required super.sortOrder,
    required super.items,
  });

  factory MenuCategoryModel.fromJson(Map<String, dynamic> json) {
    return MenuCategoryModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      sortOrder: json['sort_order'] as int? ?? 0,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => MenuItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
