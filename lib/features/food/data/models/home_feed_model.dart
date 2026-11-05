import '../../domain/entities/home_feed_entity.dart';
import 'banner_model.dart';
import 'category_model.dart';
import 'cuisine_model.dart';
import 'restaurant_model.dart';

class HomeFreeDeliveryModel extends HomeFreeDeliveryEntity {
  const HomeFreeDeliveryModel({
    required super.title,
    required super.minOrderAmount,
    super.endsAt,
  });

  factory HomeFreeDeliveryModel.fromJson(Map<String, dynamic> json) {
    return HomeFreeDeliveryModel(
      title: json['title'] as String? ?? '',
      minOrderAmount: (json['min_order_amount'] as num?)?.toDouble() ?? 0.0,
      endsAt:
          json['ends_at'] != null
              ? DateTime.tryParse(json['ends_at'].toString())
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'min_order_amount': minOrderAmount,
      'ends_at': endsAt?.toIso8601String(),
    };
  }
}

class HomeFeedModel extends HomeFeedEntity {
  const HomeFeedModel({
    super.banners = const [],
    super.freeDelivery,
    required super.cuisines,
    required super.categories,
    required super.promoted,
    required super.nearby,
    required super.topRated,
  });

  factory HomeFeedModel.fromJson(Map<String, dynamic> json) {
    return HomeFeedModel(
      banners:
          (json['banners'] as List<dynamic>?)
              ?.map((e) => BannerModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      freeDelivery:
          json['free_delivery'] is Map<String, dynamic>
              ? HomeFreeDeliveryModel.fromJson(
                json['free_delivery'] as Map<String, dynamic>,
              )
              : null,
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
      'banners':
          banners
              .map(
                (e) =>
                    e is BannerModel
                        ? e.toJson()
                        : BannerModel(
                          id: e.id,
                          title: e.title,
                          mediaUrl: e.mediaUrl,
                          mediaType: e.mediaType,
                          placement: e.placement,
                          actionType: e.actionType,
                          actionValue: e.actionValue,
                          sortOrder: e.sortOrder,
                        ).toJson(),
              )
              .toList(),
      if (freeDelivery != null)
        'free_delivery':
            HomeFreeDeliveryModel(
              title: freeDelivery!.title,
              minOrderAmount: freeDelivery!.minOrderAmount,
              endsAt: freeDelivery!.endsAt,
            ).toJson(),
      'cuisines': cuisines.map((e) => (e as CuisineModel).toJson()).toList(),
      'categories': categories.map((e) => (e as CategoryModel).toJson()).toList(),
      'promoted': promoted.map((e) => (e as RestaurantModel).toJson()).toList(),
      'nearby': nearby.map((e) => (e as RestaurantModel).toJson()).toList(),
      'top_rated': topRated.map((e) => (e as RestaurantModel).toJson()).toList(),
    };
  }
}
