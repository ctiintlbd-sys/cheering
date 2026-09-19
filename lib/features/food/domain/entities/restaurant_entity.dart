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
  final double? distanceKm;
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
    this.distanceKm,
    required this.isFavorite,
    this.description,
    this.phone,
    this.addressLine,
    this.latitude,
    this.longitude,
    this.businessHours,
    this.promotions,
  });

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
