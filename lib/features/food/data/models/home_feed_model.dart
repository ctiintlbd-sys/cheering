import '../../domain/entities/home_feed_entity.dart';
import 'cuisine_model.dart';
import 'category_model.dart';
import 'restaurant_model.dart';

class HomeFeedModel extends HomeFeedEntity {
  const HomeFeedModel({
    required super.cuisines,
    required super.categories,
    required super.promoted,
    required super.nearby,
    required super.topRated,
  });

  factory HomeFeedModel.fromJson(Map<String, dynamic> json) {
    return HomeFeedModel(
      cuisines:
          (json['cuisines'] as List<dynamic>?)
              ?.map((e) => CuisineModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      promoted:
          (json['promoted'] as List<dynamic>?)
              ?.map((e) => RestaurantModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      nearby:
          (json['nearby'] as List<dynamic>?)
              ?.map((e) => RestaurantModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      topRated:
          (json['top_rated'] as List<dynamic>?)
              ?.map((e) => RestaurantModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cuisines': cuisines.map((e) => (e as CuisineModel).toJson()).toList(),
      'categories': categories
          .map((e) => (e as CategoryModel).toJson())
          .toList(),
      'promoted': promoted.map((e) => (e as RestaurantModel).toJson()).toList(),
      'nearby': nearby.map((e) => (e as RestaurantModel).toJson()).toList(),
      'top_rated': topRated
          .map((e) => (e as RestaurantModel).toJson())
          .toList(),
    };
  }
}
