import 'package:equatable/equatable.dart';
import 'delivery_option_entity.dart';

class FreeDeliveryEntity extends Equatable {
  final String title;
  final double minOrderAmount;
  final DateTime? endsAt;

  const FreeDeliveryEntity({
    required this.title,
    required this.minOrderAmount,
    this.endsAt,
  });

  @override
  List<Object?> get props => [title, minOrderAmount, endsAt];
}

class CheckoutSummaryEntity extends Equatable {
  final double itemTotal;
  final double deliveryFee;
  final double deliveryDiscount;
  final String deliveryType;
  final double priorityFee;
  final double platformFee;
  final double discount;
  final double tip;
  final double grandTotal;
  final double distanceKm;
  final int estimatedDeliveryMinutes;
  final List<DeliveryOptionEntity> deliveryOptions;
  final FreeDeliveryEntity? freeDelivery;
  final String? promoCode;
  final String? promoError;

  const CheckoutSummaryEntity({
    required this.itemTotal,
    required this.deliveryFee,
    this.deliveryDiscount = 0,
    required this.deliveryType,
    required this.priorityFee,
    required this.platformFee,
    required this.discount,
    required this.tip,
    required this.grandTotal,
    required this.distanceKm,
    required this.estimatedDeliveryMinutes,
    required this.deliveryOptions,
    this.freeDelivery,
    this.promoCode,
    this.promoError,
  });

  @override
  List<Object?> get props => [
    itemTotal,
    deliveryFee,
    deliveryDiscount,
    deliveryType,
    priorityFee,
    platformFee,
    discount,
    tip,
    grandTotal,
    distanceKm,
    estimatedDeliveryMinutes,
    deliveryOptions,
    freeDelivery,
    promoCode,
    promoError,
  ];
}
