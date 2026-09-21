import 'package:equatable/equatable.dart';

class CheckoutSummaryEntity extends Equatable {
  final double itemTotal;
  final double deliveryFee;
  final double packagingFee;
  final double taxAmount;
  final double platformFee;
  final double discount;
  final double tip;
  final double grandTotal;
  final double distanceKm;
  final int estimatedDeliveryMinutes;
  final String? promoCode;
  final String? promoError;

  const CheckoutSummaryEntity({
    required this.itemTotal,
    required this.deliveryFee,
    required this.packagingFee,
    required this.taxAmount,
    required this.platformFee,
    required this.discount,
    required this.tip,
    required this.grandTotal,
    required this.distanceKm,
    required this.estimatedDeliveryMinutes,
    this.promoCode,
    this.promoError,
  });

  @override
  List<Object?> get props => [
        itemTotal,
        deliveryFee,
        packagingFee,
        taxAmount,
        platformFee,
        discount,
        tip,
        grandTotal,
        distanceKm,
        estimatedDeliveryMinutes,
        promoCode,
        promoError,
      ];
}
