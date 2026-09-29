import 'package:equatable/equatable.dart';
import 'package:cheering/features/tracking/domain/entities/order_tracking_entity.dart';

class OrderEntity extends Equatable {
  final String id;
  final int orderNumber;
  final String status;
  final String restaurantId;
  final String restaurantName;
  final String? restaurantLogoUrl;
  final int itemCount;
  final double grandTotal;
  final String paymentMethod;
  final String paymentStatus;
  final DateTime? placedAt;
  final DateTime? deliveredAt;
  final DateTime? scheduledFor;
  final DateTime? estimatedDeliveryAt;
  final bool canReview;
  final bool canCancel;
  final TrackingRiderEntity? rider;

  const OrderEntity({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.restaurantId,
    required this.restaurantName,
    this.restaurantLogoUrl,
    required this.itemCount,
    required this.grandTotal,
    required this.paymentMethod,
    required this.paymentStatus,
    this.placedAt,
    this.deliveredAt,
    this.scheduledFor,
    this.estimatedDeliveryAt,
    this.canReview = false,
    this.canCancel = false,
    this.rider,
  });

  @override
  List<Object?> get props => [
        id,
        orderNumber,
        status,
        restaurantId,
        restaurantName,
        restaurantLogoUrl,
        itemCount,
        grandTotal,
        paymentMethod,
        paymentStatus,
        placedAt,
        deliveredAt,
        scheduledFor,
        estimatedDeliveryAt,
        canReview,
        canCancel,
        rider,
      ];
}
