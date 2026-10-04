import 'package:equatable/equatable.dart';
import 'promotion_entity.dart';

class BusinessHoursEntity extends Equatable {
  final bool isOpen;
  final String? opensAt;
  final String? closesAt;

  const BusinessHoursEntity({
    required this.isOpen,
    this.opensAt,
    this.closesAt,
  });

  @override
  List<Object?> get props => [isOpen, opensAt, closesAt];
}

class RestaurantEntity extends Equatable {
  final String id;
  final String name;
  final String slug;
  final List<String> cuisineTypes;
  final String? logoUrl;
  final String? coverImageUrl;
  final double ratingAvg;
  final int ratingCount;
  final int avgPrepTimeMins;
  final double deliveryFee;
  final double minOrderAmount;
  final bool isOpen;
  final double distanceKm;
  final bool isFavorite;

  // Details fields
  final String? description;
  final String? phone;
  final String? addressLine;
  final double? latitude;
  final double? longitude;
  final Map<String, BusinessHoursEntity>? businessHours;
  final List<PromotionEntity>? promotions;

  const RestaurantEntity({
    required this.id,
    required this.name,
    required this.slug,
    required this.cuisineTypes,
    this.logoUrl,
    this.coverImageUrl,
    required this.ratingAvg,
    required this.ratingCount,
    required this.avgPrepTimeMins,
    required this.deliveryFee,
    required this.minOrderAmount,
    required this.isOpen,
    this.distanceKm = 0.0,
    required this.isFavorite,
    this.description,
    this.phone,
    this.addressLine,
    this.latitude,
    this.longitude,
    this.businessHours,
    this.promotions,
  });

  factory RestaurantEntity.stub({
    required String id,
    required String name,
    required double minOrderAmount,
    required bool isOpen,
  }) {
    return RestaurantEntity(
      id: id,
      name: name,
      slug: '',
      cuisineTypes: const [],
      ratingAvg: 0.0,
      ratingCount: 0,
      avgPrepTimeMins: 0,
      deliveryFee: 0.0,
      minOrderAmount: minOrderAmount,
      isOpen: isOpen,
      isFavorite: false,
    );
  }

  RestaurantEntity copyWith({
    String? id,
    String? name,
    String? slug,
    List<String>? cuisineTypes,
    String? logoUrl,
    String? coverImageUrl,
    double? ratingAvg,
    int? ratingCount,
    int? avgPrepTimeMins,
    double? deliveryFee,
    double? minOrderAmount,
    bool? isOpen,
    double? distanceKm,
    bool? isFavorite,
    String? description,
    String? phone,
    String? addressLine,
    double? latitude,
    double? longitude,
    Map<String, BusinessHoursEntity>? businessHours,
    List<PromotionEntity>? promotions,
  }) {
    return RestaurantEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      cuisineTypes: cuisineTypes ?? this.cuisineTypes,
      logoUrl: logoUrl ?? this.logoUrl,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      ratingAvg: ratingAvg ?? this.ratingAvg,
      ratingCount: ratingCount ?? this.ratingCount,
      avgPrepTimeMins: avgPrepTimeMins ?? this.avgPrepTimeMins,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      minOrderAmount: minOrderAmount ?? this.minOrderAmount,
      isOpen: isOpen ?? this.isOpen,
      distanceKm: distanceKm ?? this.distanceKm,
      isFavorite: isFavorite ?? this.isFavorite,
      description: description ?? this.description,
      phone: phone ?? this.phone,
      addressLine: addressLine ?? this.addressLine,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      businessHours: businessHours ?? this.businessHours,
      promotions: promotions ?? this.promotions,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    slug,
    cuisineTypes,
    logoUrl,
    coverImageUrl,
    ratingAvg,
    ratingCount,
    avgPrepTimeMins,
    deliveryFee,
    minOrderAmount,
    isOpen,
    distanceKm,
    isFavorite,
    description,
    phone,
    addressLine,
    latitude,
    longitude,
    businessHours,
    promotions,
  ];
}
