import '../../domain/entities/checkout_summary_entity.dart';
import 'delivery_option_model.dart';

class FreeDeliveryModel extends FreeDeliveryEntity {
  const FreeDeliveryModel({
    required super.title,
    required super.minOrderAmount,
    super.endsAt,
  });

  factory FreeDeliveryModel.fromJson(Map<String, dynamic> json) {
    return FreeDeliveryModel(
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

class CheckoutSummaryModel extends CheckoutSummaryEntity {
  const CheckoutSummaryModel({
    required super.itemTotal,
    required super.deliveryFee,
    super.deliveryDiscount = 0,
    required super.deliveryType,
    required super.priorityFee,
    required super.platformFee,
    required super.discount,
    required super.tip,
    required super.grandTotal,
    required super.distanceKm,
    required super.estimatedDeliveryMinutes,
    required super.deliveryOptions,
    super.freeDelivery,
    super.promoCode,
    super.promoError,
  });

  factory CheckoutSummaryModel.fromJson(Map<String, dynamic> json) {
    return CheckoutSummaryModel(
      itemTotal: (json['item_total'] as num?)?.toDouble() ?? 0,
      deliveryFee: (json['delivery_fee'] as num?)?.toDouble() ?? 0,
      deliveryDiscount: (json['delivery_discount'] as num?)?.toDouble() ?? 0,
      deliveryType: json['delivery_type'] as String? ?? 'STANDARD',
      priorityFee: (json['priority_fee'] as num?)?.toDouble() ?? 0,
      platformFee: (json['platform_fee'] as num?)?.toDouble() ?? 0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0,
      tip: (json['tip'] as num?)?.toDouble() ?? 0,
      grandTotal: (json['grand_total'] as num?)?.toDouble() ?? 0,
      distanceKm: (json['distance_km'] as num?)?.toDouble() ?? 0,
      estimatedDeliveryMinutes:
          (json['estimated_delivery_minutes'] as num?)?.toInt() ?? 0,
      deliveryOptions:
          (json['delivery_options'] as List<dynamic>? ?? [])
              .map(
                (e) => DeliveryOptionModel.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
      freeDelivery:
          json['free_delivery'] is Map<String, dynamic>
              ? FreeDeliveryModel.fromJson(
                json['free_delivery'] as Map<String, dynamic>,
              )
              : null,
      promoCode: json['promo_code'] as String?,
      promoError: json['promo_error'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_total': itemTotal,
      'delivery_fee': deliveryFee,
      'delivery_discount': deliveryDiscount,
      'delivery_type': deliveryType,
      'priority_fee': priorityFee,
      'platform_fee': platformFee,
      'discount': discount,
      'tip': tip,
      'grand_total': grandTotal,
      'distance_km': distanceKm,
      'estimated_delivery_minutes': estimatedDeliveryMinutes,
      'delivery_options':
          deliveryOptions
              .map(
                (e) =>
                    DeliveryOptionModel(
                      type: e.type,
                      label: e.label,
                      extraFee: e.extraFee,
                      etaMinMinutes: e.etaMinMinutes,
                      etaMaxMinutes: e.etaMaxMinutes,
                      isSelected: e.isSelected,
                    ).toJson(),
              )
              .toList(),
      if (freeDelivery != null)
        'free_delivery':
            FreeDeliveryModel(
              title: freeDelivery!.title,
              minOrderAmount: freeDelivery!.minOrderAmount,
              endsAt: freeDelivery!.endsAt,
            ).toJson(),
      'promo_code': promoCode,
      'promo_error': promoError,
    };
  }
}
