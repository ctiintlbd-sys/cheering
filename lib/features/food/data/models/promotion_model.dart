import '../../domain/entities/promotion_entity.dart';

class PromotionModel extends PromotionEntity {
  const PromotionModel({
    required super.code,
    required super.title,
    required super.discountType,
    required super.discountValue,
    required super.minOrderAmount,
    super.maxDiscount,
    required super.validUntil,
  });

  factory PromotionModel.fromJson(Map<String, dynamic> json) {
    return PromotionModel(
      code: json['code'] as String? ?? '',
      title: json['title'] as String? ?? '',
      discountType: json['discount_type'] as String? ?? '',
      discountValue: (json['discount_value'] as num?)?.toDouble() ?? 0.0,
      minOrderAmount: (json['min_order_amount'] as num?)?.toDouble() ?? 0.0,
      maxDiscount: (json['max_discount'] as num?)?.toDouble(),
      validUntil:
          DateTime.tryParse(json['valid_until']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'title': title,
      'discount_type': discountType,
      'discount_value': discountValue,
      'min_order_amount': minOrderAmount,
      'max_discount': maxDiscount,
      'valid_until': validUntil.toIso8601String(),
    };
  }
}
