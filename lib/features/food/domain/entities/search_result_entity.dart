import 'package:equatable/equatable.dart';
import 'restaurant_entity.dart';
import 'menu_entity.dart';
import 'category_entity.dart';

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
