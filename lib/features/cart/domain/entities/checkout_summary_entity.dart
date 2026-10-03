import 'package:equatable/equatable.dart';
import 'delivery_option_entity.dart';

class CheckoutSummaryEntity extends Equatable {
  final double itemTotal;
  final double deliveryFee;
  final String deliveryType;
  final double priorityFee;
  final double platformFee;
  final double discount;
  final double tip;
  final double grandTotal;
  final double distanceKm;
  final int estimatedDeliveryMinutes;
  final List<DeliveryOptionEntity> deliveryOptions;
  final String? promoCode;
  final String? promoError;

  const CheckoutSummaryEntity({
    required this.itemTotal,
    required this.deliveryFee,
    required this.deliveryType,
    required this.priorityFee,
    required this.platformFee,
    required this.discount,
    required this.tip,
    required this.grandTotal,
    required this.distanceKm,
    required this.estimatedDeliveryMinutes,
    required this.deliveryOptions,
    this.promoCode,
    this.promoError,
  });

  @override
  List<Object?> get props => [
    itemTotal,
    deliveryFee,
    deliveryType,
    priorityFee,
    platformFee,
    discount,
    tip,
    grandTotal,
    distanceKm,
    estimatedDeliveryMinutes,
    deliveryOptions,
    promoCode,
    promoError,
  ];
}