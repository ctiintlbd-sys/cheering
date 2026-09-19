import 'package:equatable/equatable.dart';
import 'cuisine_entity.dart';
import 'category_entity.dart';
import 'restaurant_entity.dart';

class HomeFeedEntity extends Equatable {
  final List<CuisineEntity> cuisines;
  final List<CategoryEntity> categories;
  final List<RestaurantEntity> promoted;
  final List<RestaurantEntity> nearby;
  final List<RestaurantEntity> topRated;

  const HomeFeedEntity({
    required this.cuisines,
    required this.categories,
    required this.promoted,
    required this.nearby,
    required this.topRated,
  });

  @override
  List<Object?> get props => [cuisines, categories, promoted, nearby, topRated];
}
