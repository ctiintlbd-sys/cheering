import '../../domain/entities/restaurant_entity.dart';
import 'promotion_model.dart';

class BusinessHoursModel extends BusinessHoursEntity {
  const BusinessHoursModel({
    required super.isOpen,
    super.opensAt,
    super.closesAt,
  });

  factory BusinessHoursModel.fromJson(Map<String, dynamic> json) {
    return BusinessHoursModel(
      isOpen: json['is_open'] == true,
      opensAt: json['opens_at'] as String?,
      closesAt: json['closes_at'] as String?,
    );
  }
}

class RestaurantModel extends RestaurantEntity {
  const RestaurantModel({
    required super.id,
    required super.name,
    required super.slug,
    required super.cuisineTypes,
    super.logoUrl,
    super.coverImageUrl,
    required super.ratingAvg,
    required super.ratingCount,
    required super.avgPrepTimeMins,
    required super.deliveryFee,
    required super.minOrderAmount,
    required super.isOpen,
    super.distanceKm,
    required super.isFavorite,
    super.description,
    super.phone,
    super.addressLine,
    super.latitude,
    super.longitude,
    super.businessHours,
    super.promotions,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      cuisineTypes: (json['cuisine_types'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      logoUrl: json['logo_url'] as String?,
      coverImageUrl: json['cover_image_url'] as String?,
      ratingAvg: (json['rating_avg'] as num?)?.toDouble() ?? 0.0,
      ratingCount: json['rating_count'] as int? ?? 0,
      avgPrepTimeMins: json['avg_prep_time_mins'] as int? ?? 0,
      deliveryFee: (json['delivery_fee'] as num?)?.toDouble() ?? 0.0,
      minOrderAmount: (json['min_order_amount'] as num?)?.toDouble() ?? 0.0,
      isOpen: json['is_open'] == true,
      distanceKm: (json['distance_km'] as num?)?.toDouble(),
      isFavorite: json['is_favorite'] == true,
      description: json['description'] as String?,
      phone: json['phone'] as String?,
      addressLine: json['address_line'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      businessHours: (json['business_hours'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, BusinessHoursModel.fromJson(value as Map<String, dynamic>)),
      ),
      promotions: (json['promotions'] as List<dynamic>?)
          ?.map((e) => PromotionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
