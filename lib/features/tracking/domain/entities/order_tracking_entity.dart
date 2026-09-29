import 'package:equatable/equatable.dart';

class TrackingRiderEntity extends Equatable {
  final String id;
  final String name;
  final String? phone;
  final String? photoUrl;
  final double? ratingAvg;
  final String? vehicleType;

  const TrackingRiderEntity({
    required this.id,
    required this.name,
    this.phone,
    this.photoUrl,
    this.ratingAvg,
    this.vehicleType,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    phone,
    photoUrl,
    ratingAvg,
    vehicleType,
  ];
}

class RiderLocationEntity extends Equatable {
  final double latitude;
  final double longitude;
  final double? heading;
  final double? speedKph;
  final DateTime? updatedAt;

  const RiderLocationEntity({
    required this.latitude,
    required this.longitude,
    this.heading,
    this.speedKph,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    latitude,
    longitude,
    heading,
    speedKph,
    updatedAt,
  ];
}

class TrackingTimelineEntity extends Equatable {
  final String status;
  final DateTime at;
  final String? note;

  const TrackingTimelineEntity({
    required this.status,
    required this.at,
    this.note,
  });

  @override
  List<Object?> get props => [status, at, note];
}

class OrderTrackingEntity extends Equatable {
  final String orderId;
  final String status;
  final List<TrackingTimelineEntity> timeline;
  final double restaurantLatitude;
  final double restaurantLongitude;
  final String restaurantName;
  final double deliveryLatitude;
  final double deliveryLongitude;
  final String deliveryAddressText;
  final DateTime? estimatedDeliveryAt;
  final int? etaMinutes;
  final TrackingRiderEntity? rider;
  final RiderLocationEntity? riderLocation;
  final bool liveTrackingAvailable;

  const OrderTrackingEntity({
    required this.orderId,
    required this.status,
    required this.timeline,
    required this.restaurantLatitude,
    required this.restaurantLongitude,
    required this.restaurantName,
    required this.deliveryLatitude,
    required this.deliveryLongitude,
    required this.deliveryAddressText,
    this.estimatedDeliveryAt,
    this.etaMinutes,
    this.rider,
    this.riderLocation,
    this.liveTrackingAvailable = false,
  });

  @override
  List<Object?> get props => [
    orderId,
    status,
    timeline,
    restaurantLatitude,
    restaurantLongitude,
    restaurantName,
    deliveryLatitude,
    deliveryLongitude,
    deliveryAddressText,
    estimatedDeliveryAt,
    etaMinutes,
    rider,
    riderLocation,
    liveTrackingAvailable,
  ];
}
