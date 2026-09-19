import '../../domain/entities/search_result_entity.dart';
import 'restaurant_model.dart';
import 'menu_model.dart';
import 'category_model.dart';

class SearchResultModel extends SearchResultEntity {
  const SearchResultModel({
    required super.restaurants,
    required super.items,
    required super.categories,
  });

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    return SearchResultModel(
      restaurants: (json['restaurants'] as List<dynamic>?)
              ?.map((e) => RestaurantModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => MenuItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      categories: (json['categories'] as List<dynamic>?)
              ?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
