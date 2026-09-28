import 'package:equatable/equatable.dart';

import '../../../food/domain/entities/category_entity.dart';
import '../../../food/domain/entities/menu_entity.dart';
import '../../../food/domain/entities/restaurant_entity.dart';

class SearchResultEntity extends Equatable {
  final List<RestaurantEntity> restaurants;
  final List<MenuItemEntity> items;
  final List<CategoryEntity> categories;

  const SearchResultEntity({
    required this.restaurants,
    required this.items,
    required this.categories,
  });

  @override
  List<Object?> get props => [restaurants, items, categories];
}
