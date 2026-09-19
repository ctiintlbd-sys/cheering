import 'package:equatable/equatable.dart';

class PromotionEntity extends Equatable {
  final String code;
  final String title;
  final String discountType;
  final double discountValue;
  final double minOrderAmount;
  final double? maxDiscount;
  final DateTime validUntil;

  const PromotionEntity({
    required this.code,
    required this.title,
    required this.discountType,
    required this.discountValue,
    required this.minOrderAmount,
    this.maxDiscount,
    required this.validUntil,
  });

  @override
  List<Object?> get props => [
    code, title, discountType, discountValue, minOrderAmount, maxDiscount, validUntil
  ];
}
