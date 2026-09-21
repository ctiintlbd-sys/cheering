import '../../domain/entities/checkout_summary_entity.dart';

class CheckoutSummaryModel extends CheckoutSummaryEntity {
  const CheckoutSummaryModel({
    required super.itemTotal,
    required super.deliveryFee,
    required super.packagingFee,
    required super.taxAmount,
    required super.platformFee,
    required super.discount,
    required super.tip,
    required super.grandTotal,
    required super.distanceKm,
    required super.estimatedDeliveryMinutes,
    super.promoCode,
    super.promoError,
  });

  factory CheckoutSummaryModel.fromJson(Map<String, dynamic> json) {
    return CheckoutSummaryModel(
      itemTotal: (json['item_total'] as num).toDouble(),
      deliveryFee: (json['delivery_fee'] as num).toDouble(),
      packagingFee: (json['packaging_fee'] as num).toDouble(),
      taxAmount: (json['tax_amount'] as num).toDouble(),
      platformFee: (json['platform_fee'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      tip: (json['tip'] as num).toDouble(),
      grandTotal: (json['grand_total'] as num).toDouble(),
      distanceKm: (json['distance_km'] as num).toDouble(),
      estimatedDeliveryMinutes: json['estimated_delivery_minutes'] as int? ?? 0,
      promoCode: json['promo_code'] as String?,
      promoError: json['promo_error'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_total': itemTotal,
      'delivery_fee': deliveryFee,
      'packaging_fee': packagingFee,
      'tax_amount': taxAmount,
      'platform_fee': platformFee,
      'discount': discount,
      'tip': tip,
      'grand_total': grandTotal,
      'distance_km': distanceKm,
      'estimated_delivery_minutes': estimatedDeliveryMinutes,
      'promo_code': promoCode,
      'promo_error': promoError,
    };
  }
}
