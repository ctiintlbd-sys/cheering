import 'package:equatable/equatable.dart';

class CreateOrderParams extends Equatable {
  final String paymentMethod;
  final String addressId;
  final String? promoCode;
  final double? tip;
  final String? specialInstructions;
  final DateTime? scheduledFor;

  const CreateOrderParams({
    required this.paymentMethod,
    required this.addressId,
    this.promoCode,
    this.tip,
    this.specialInstructions,
    this.scheduledFor,
  });

  Map<String, dynamic> toMap() {
    return {
      'payment_method': paymentMethod,
      'address_id': addressId,
      if (promoCode != null && promoCode!.isNotEmpty) 'promo_code': promoCode,
      if (tip != null) 'tip': tip,
      if (specialInstructions != null)
        'special_instructions': specialInstructions,
      if (scheduledFor != null)
        'scheduled_for': scheduledFor!.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        paymentMethod,
        addressId,
        promoCode,
        tip,
        specialInstructions,
        scheduledFor,
      ];
}
