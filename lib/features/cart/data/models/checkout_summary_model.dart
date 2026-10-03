import '../../domain/entities/checkout_summary_entity.dart';
import 'delivery_option_model.dart';

class CheckoutSummaryModel extends CheckoutSummaryEntity {
  const CheckoutSummaryModel({
    required super.itemTotal,
    required super.deliveryFee,
    required super.deliveryType,
    required super.priorityFee,
    required super.platformFee,
    required super.discount,
    required super.tip,
    required super.grandTotal,
    required super.distanceKm,
    required super.estimatedDeliveryMinutes,
    required super.deliveryOptions,
    super.promoCode,
    super.promoError,
  });

  factory CheckoutSummaryModel.fromJson(Map<String, dynamic> json) {
    return CheckoutSummaryModel(
      itemTotal: (json['item_total'] as num?)?.toDouble() ?? 0,
      deliveryFee: (json['delivery_fee'] as num?)?.toDouble() ?? 0,
      deliveryType: json['delivery_type'] as String? ?? 'STANDARD',
      priorityFee: (json['priority_fee'] as num?)?.toDouble() ?? 0,
      platformFee: (json['platform_fee'] as num?)?.toDouble() ?? 0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0,
      tip: (json['tip'] as num?)?.toDouble() ?? 0,
      grandTotal: (json['grand_total'] as num?)?.toDouble() ?? 0,
      distanceKm: (json['distance_km'] as num?)?.toDouble() ?? 0,
      estimatedDeliveryMinutes:
      (json['estimated_delivery_minutes'] as num?)?.toInt() ?? 0,
      deliveryOptions: (json['delivery_options'] as List<dynamic>? ?? [])
          .map((e) => DeliveryOptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      promoCode: json['promo_code'] as String?,
      promoError: json['promo_error'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_total': itemTotal,
      'delivery_fee': deliveryFee,
      'delivery_type': deliveryType,
      'priority_fee': priorityFee,
      'platform_fee': platformFee,
      'discount': discount,
      'tip': tip,
      'grand_total': grandTotal,
      'distance_km': distanceKm,
      'estimated_delivery_minutes': estimatedDeliveryMinutes,
      'delivery_options': deliveryOptions
          .map((e) => DeliveryOptionModel(
        type: e.type,
        label: e.label,
        extraFee: e.extraFee,
        etaMinMinutes: e.etaMinMinutes,
        etaMaxMinutes: e.etaMaxMinutes,
        isSelected: e.isSelected,
      ).toJson())
          .toList(),
      'promo_code': promoCode,
      'promo_error': promoError,
    };
  }
}