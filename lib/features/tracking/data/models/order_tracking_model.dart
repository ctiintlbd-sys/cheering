import '../../domain/entities/order_tracking_entity.dart';

class TrackingRiderModel extends TrackingRiderEntity {
  const TrackingRiderModel({
    required super.id,
    required super.name,
    super.phone,
    super.photoUrl,
  });

  factory TrackingRiderModel.fromJson(Map<String, dynamic> json) {
    return TrackingRiderModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? json['full_name'] as String? ?? '',
      phone: json['phone'] as String? ?? json['phone_number'] as String?,
      photoUrl: json['photo_url'] as String? ?? json['avatar_url'] as String?,
    );
  }
}

class RiderLocationModel extends RiderLocationEntity {
  const RiderLocationModel({
    required super.latitude,
    required super.longitude,
    super.updatedAt,
  });

  factory RiderLocationModel.fromJson(Map<String, dynamic> json) {
    return RiderLocationModel(
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String).toLocal()
          : null,
    );
  }
}

class TrackingTimelineModel extends TrackingTimelineEntity {
  const TrackingTimelineModel({
    required super.status,
    required super.at,
    super.note,
  });

  factory TrackingTimelineModel.fromJson(Map<String, dynamic> json) {
    return TrackingTimelineModel(
      status: json['status'] as String? ?? '',
      at: DateTime.parse(json['at'] as String).toLocal(),
      note: json['note'] as String?,
    );
  }
}

class OrderTrackingModel extends OrderTrackingEntity {
  const OrderTrackingModel({
    required super.orderId,
    required super.status,
    required super.timeline,
    required super.restaurantLatitude,
    required super.restaurantLongitude,
    required super.restaurantName,
    required super.deliveryLatitude,
    required super.deliveryLongitude,
    required super.deliveryAddressText,
    super.estimatedDeliveryAt,
    super.etaMinutes,
    super.rider,
    super.riderLocation,
    super.liveTrackingAvailable,
  });

  factory OrderTrackingModel.fromJson(Map<String, dynamic> json) {
    final riderJson = json['rider'];
    final locationJson = json['rider_location'];

    return OrderTrackingModel(
      orderId: json['order_id'] as String? ?? '',
      status: json['status'] as String? ?? 'PENDING',
      timeline: (json['timeline'] as List<dynamic>?)
              ?.map(
                (e) => TrackingTimelineModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          const [],
      restaurantLatitude:
          (json['restaurant_latitude'] as num?)?.toDouble() ?? 0,
      restaurantLongitude:
          (json['restaurant_longitude'] as num?)?.toDouble() ?? 0,
      restaurantName: json['restaurant_name'] as String? ?? '',
      deliveryLatitude: (json['delivery_latitude'] as num?)?.toDouble() ?? 0,
      deliveryLongitude: (json['delivery_longitude'] as num?)?.toDouble() ?? 0,
      deliveryAddressText: json['delivery_address_text'] as String? ?? '',
      estimatedDeliveryAt: json['estimated_delivery_at'] != null
          ? DateTime.parse(json['estimated_delivery_at'] as String).toLocal()
          : null,
      etaMinutes: (json['eta_minutes'] as num?)?.toInt(),
      rider: riderJson is Map<String, dynamic>
          ? TrackingRiderModel.fromJson(riderJson)
          : null,
      riderLocation: locationJson is Map<String, dynamic>
          ? RiderLocationModel.fromJson(locationJson)
          : null,
      liveTrackingAvailable: json['live_tracking_available'] as bool? ?? false,
    );
  }
}
