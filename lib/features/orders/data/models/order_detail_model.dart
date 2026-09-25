import '../../domain/entities/order_detail_entity.dart';

class OrderItemModel extends OrderItemEntity {
  const OrderItemModel({
    required super.id,
    required super.menuItemId,
    required super.name,
    required super.quantity,
    required super.unitPrice,
    required super.addOnsTotal,
    required super.lineTotal,
    super.variantName,
    required super.addOnNames,
    super.imageUrl,
    super.notes,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as String? ?? '',
      menuItemId: json['menu_item_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 1,
      unitPrice: (json['unit_price'] as num?)?.toDouble() ?? 0.0,
      addOnsTotal: (json['add_ons_total'] as num?)?.toDouble() ?? 0.0,
      lineTotal: (json['line_total'] as num?)?.toDouble() ?? 0.0,
      variantName: json['variant_name'] as String?,
      addOnNames: (json['add_on_names'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      imageUrl: json['image_url'] as String?,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'menu_item_id': menuItemId,
      'name': name,
      'quantity': quantity,
      'unit_price': unitPrice,
      'add_ons_total': addOnsTotal,
      'line_total': lineTotal,
      'variant_name': variantName,
      'add_on_names': addOnNames,
      'image_url': imageUrl,
      'notes': notes,
    };
  }
}

class OrderTimelineModel extends OrderTimelineEntity {
  const OrderTimelineModel({
    required super.status,
    required super.at,
    required super.note,
  });

  factory OrderTimelineModel.fromJson(Map<String, dynamic> json) {
    return OrderTimelineModel(
      status: json['status'] as String? ?? '',
      at: DateTime.parse(json['at'] as String).toLocal(),
      note: json['note'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'at': at.toUtc().toIso8601String(),
      'note': note,
    };
  }
}

class OrderDetailModel extends OrderDetailEntity {
  const OrderDetailModel({
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
    required super.items,
    required super.itemTotal,
    required super.deliveryFee,
    required super.packagingFee,
    required super.taxAmount,
    required super.platformFee,
    required super.discount,
    required super.tip,
    required super.deliveryAddressText,
    super.deliveryLatitude,
    super.deliveryLongitude,
    super.deliveryContactPhone,
    super.specialInstructions,
    super.cancellationReason,
    required super.timeline,
    super.rider,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(
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
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      itemTotal: (json['item_total'] as num?)?.toDouble() ?? 0.0,
      deliveryFee: (json['delivery_fee'] as num?)?.toDouble() ?? 0.0,
      packagingFee: (json['packaging_fee'] as num?)?.toDouble() ?? 0.0,
      taxAmount: (json['tax_amount'] as num?)?.toDouble() ?? 0.0,
      platformFee: (json['platform_fee'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      tip: (json['tip'] as num?)?.toDouble() ?? 0.0,
      deliveryAddressText: json['delivery_address_text'] as String? ?? '',
      deliveryLatitude: (json['delivery_latitude'] as num?)?.toDouble(),
      deliveryLongitude: (json['delivery_longitude'] as num?)?.toDouble(),
      deliveryContactPhone: json['delivery_contact_phone'] as String?,
      specialInstructions: json['special_instructions'] as String?,
      cancellationReason: json['cancellation_reason'] as String?,
      timeline: (json['timeline'] as List<dynamic>?)
              ?.map((e) => OrderTimelineModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      rider: json['rider'],
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
      'items': items.map((e) => (e as OrderItemModel).toJson()).toList(),
      'item_total': itemTotal,
      'delivery_fee': deliveryFee,
      'packaging_fee': packagingFee,
      'tax_amount': taxAmount,
      'platform_fee': platformFee,
      'discount': discount,
      'tip': tip,
      'delivery_address_text': deliveryAddressText,
      'delivery_latitude': deliveryLatitude,
      'delivery_longitude': deliveryLongitude,
      'delivery_contact_phone': deliveryContactPhone,
      'special_instructions': specialInstructions,
      'cancellation_reason': cancellationReason,
      'timeline':
          timeline.map((e) => (e as OrderTimelineModel).toJson()).toList(),
      'rider': rider,
    };
  }
}
