import 'package:equatable/equatable.dart';

class CheckoutSummaryParams extends Equatable {
  final String addressId;
  final String? promoCode;
  final double? tip;
  final String deliveryType;

  const CheckoutSummaryParams({
    required this.addressId,
    this.promoCode,
    this.tip,
    this.deliveryType = 'STANDARD',
  });

  Map<String, dynamic> toQueryParameters() {
    final query = <String, dynamic>{
      'address_id': addressId,
      'delivery_type': deliveryType,
    };
    if (promoCode != null) query['promo_code'] = promoCode;
    if (tip != null) query['tip'] = tip;
    return query;
  }

  @override
  List<Object?> get props => [addressId, promoCode, tip, deliveryType];
}