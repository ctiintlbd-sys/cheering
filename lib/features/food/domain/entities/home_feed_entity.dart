import 'package:equatable/equatable.dart';
import 'banner_entity.dart';
import 'category_entity.dart';
import 'cuisine_entity.dart';
import 'restaurant_entity.dart';

class HomeFreeDeliveryEntity extends Equatable {
  final String title;
  final double minOrderAmount;
  final DateTime? endsAt;

  const HomeFreeDeliveryEntity({
    required this.title,
    required this.minOrderAmount,
    this.endsAt,
  });

  @override
  List<Object?> get props => [title, minOrderAmount, endsAt];
}

class HomeFeedEntity extends Equatable {
  final List<BannerEntity> banners;
  final HomeFreeDeliveryEntity? freeDelivery;
  final List<CuisineEntity> cuisines;
  final List<CategoryEntity> categories;
  final List<RestaurantEntity> promoted;
  final List<RestaurantEntity> nearby;
  final List<RestaurantEntity> topRated;

  const HomeFeedEntity({
    this.banners = const [],
    this.freeDelivery,
    required this.cuisines,
    required this.categories,
    required this.promoted,
    required this.nearby,
    required this.topRated,
  });

  @override
  List<Object?> get props => [
    banners,
    freeDelivery,
    cuisines,
    categories,
    promoted,
    nearby,
    topRated,
  ];
}
