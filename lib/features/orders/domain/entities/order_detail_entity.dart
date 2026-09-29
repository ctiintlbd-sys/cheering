import 'package:equatable/equatable.dart';
import 'package:cheering/features/tracking/domain/entities/order_tracking_entity.dart';
import 'order_entity.dart';

class OrderItemEntity extends Equatable {
  final String id;
  final String menuItemId;
  final String name;
  final int quantity;
  final double unitPrice;
  final double addOnsTotal;
  final double lineTotal;
  final String? variantName;
  final List<String> addOnNames;
  final String? imageUrl;
  final String? notes;

  const OrderItemEntity({
    required this.id,
    required this.menuItemId,
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.addOnsTotal,
    required this.lineTotal,
    this.variantName,
    required this.addOnNames,
    this.imageUrl,
    this.notes,
  });

  @override
  List<Object?> get props => [
        id,
        menuItemId,
        name,
        quantity,
        unitPrice,
        addOnsTotal,
        lineTotal,
        variantName,
        addOnNames,
        imageUrl,
        notes,
      ];
}

class OrderTimelineEntity extends Equatable {
  final String status;
  final DateTime at;
  final String note;

  const OrderTimelineEntity({
    required this.status,
    required this.at,
    required this.note,
  });

  @override
  List<Object?> get props => [status, at, note];
}

class OrderDetailEntity extends OrderEntity {
  final List<OrderItemEntity> items;
  final double itemTotal;
  final double deliveryFee;
  final double packagingFee;
  final double taxAmount;
  final double platformFee;
  final double discount;
  final double tip;
  final String deliveryAddressText;
  final double? deliveryLatitude;
  final double? deliveryLongitude;
  final String? deliveryContactPhone;
  final String? specialInstructions;
  final String? cancellationReason;
  final List<OrderTimelineEntity> timeline;
  @override
  final TrackingRiderEntity? rider;

  const OrderDetailEntity({
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
    required this.items,
    required this.itemTotal,
    required this.deliveryFee,
    required this.packagingFee,
    required this.taxAmount,
    required this.platformFee,
    required this.discount,
    required this.tip,
    required this.deliveryAddressText,
    this.deliveryLatitude,
    this.deliveryLongitude,
    this.deliveryContactPhone,
    this.specialInstructions,
    this.cancellationReason,
    required this.timeline,
    this.rider,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        items,
        itemTotal,
        deliveryFee,
        packagingFee,
        taxAmount,
        platformFee,
        discount,
        tip,
        deliveryAddressText,
        deliveryLatitude,
        deliveryLongitude,
        deliveryContactPhone,
        specialInstructions,
        cancellationReason,
        timeline,
        rider,
      ];
}
