import 'package:equatable/equatable.dart';

class CheckoutSummaryParams extends Equatable {
  final String addressId;
  final String? promoCode;
  final double? tip;
  final String deliveryType;

  const CheckoutSummaryParams({
    required this.addressId,
    this.promoCode,
    this.tip = 0,
    this.deliveryType = 'STANDARD',
  });

  Map<String, dynamic> toQueryParameters() {
    final query = <String, dynamic>{
      'address_id': addressId,
      'delivery_type': deliveryType,
      'tip': (tip ?? 0).toInt() == (tip ?? 0) ? (tip ?? 0).toInt() : (tip ?? 0),
    };
    if (promoCode != null && promoCode!.isNotEmpty) {
      query['promo_code'] = promoCode;
    }
    return query;
  }

  @override
  List<Object?> get props => [addressId, promoCode, tip, deliveryType];
}