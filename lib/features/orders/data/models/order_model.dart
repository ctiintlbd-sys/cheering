import '../../domain/entities/order_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.orderNumber,
    required super.status,
    required super.restaurantId,
    required super.restaurantName,
    super.restaurantLogoUrl,
    required super.itemCount,
    required super.grandTotal,
    required super.paymentMethod,
    required super.paymentStatus,
    super.placedAt,
    super.deliveredAt,
    super.scheduledFor,
    super.estimatedDeliveryAt,
    super.canReview,
    super.canCancel,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String? ?? '',
      orderNumber: json['order_number'] as int? ?? 0,
      status: json['status'] as String? ?? 'PENDING',
      restaurantId: json['restaurant_id'] as String? ?? '',
      restaurantName: json['restaurant_name'] as String? ?? '',
      restaurantLogoUrl: json['restaurant_logo_url'] as String?,
      itemCount: json['item_count'] as int? ?? 0,
      grandTotal: (json['grand_total'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: json['payment_method'] as String? ?? '',
      paymentStatus: json['payment_status'] as String? ?? '',
      placedAt: json['placed_at'] != null
          ? DateTime.parse(json['placed_at'] as String).toLocal()
          : null,
      deliveredAt: json['delivered_at'] != null
          ? DateTime.parse(json['delivered_at'] as String).toLocal()
          : null,
      scheduledFor: json['scheduled_for'] != null
          ? DateTime.parse(json['scheduled_for'] as String).toLocal()
          : null,
      estimatedDeliveryAt: json['estimated_delivery_at'] != null
          ? DateTime.parse(json['estimated_delivery_at'] as String).toLocal()
          : null,
      canReview: json['can_review'] as bool? ?? false,
      canCancel: json['can_cancel'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_number': orderNumber,
      'status': status,
      'restaurant_id': restaurantId,
      'restaurant_name': restaurantName,
      'restaurant_logo_url': restaurantLogoUrl,
      'item_count': itemCount,
      'grand_total': grandTotal,
      'payment_method': paymentMethod,
      'payment_status': paymentStatus,
      'placed_at': placedAt?.toUtc().toIso8601String(),
      'delivered_at': deliveredAt?.toUtc().toIso8601String(),
      'scheduled_for': scheduledFor?.toUtc().toIso8601String(),
      'estimated_delivery_at': estimatedDeliveryAt?.toUtc().toIso8601String(),
      'can_review': canReview,
      'can_cancel': canCancel,
    };
  }
}
