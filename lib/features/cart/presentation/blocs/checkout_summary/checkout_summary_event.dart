import 'package:equatable/equatable.dart';
import '../../../domain/entities/checkout_summary_params.dart';

sealed class CheckoutSummaryEvent extends Equatable {
  const CheckoutSummaryEvent();

  @override
  List<Object?> get props => [];
}

class LoadCheckoutSummary extends CheckoutSummaryEvent {
  final CheckoutSummaryParams params;

  const LoadCheckoutSummary(this.params);

  @override
  List<Object?> get props => [params];
}

class ApplyPromoCodeEvent extends CheckoutSummaryEvent {
  final String promoCode;

  const ApplyPromoCodeEvent(this.promoCode);

  @override
  List<Object?> get props => [promoCode];
}

class UpdateTipEvent extends CheckoutSummaryEvent {
  final double tip;

  const UpdateTipEvent(this.tip);

  @override
  List<Object?> get props => [tip];
}

class UpdatePaymentMethodEvent extends CheckoutSummaryEvent {
  final String paymentMethod;

  const UpdatePaymentMethodEvent(this.paymentMethod);

  @override
  List<Object?> get props => [paymentMethod];
}

class UpdateDeliveryTypeEvent extends CheckoutSummaryEvent {
  final String deliveryType;

  const UpdateDeliveryTypeEvent(this.deliveryType);

  @override
  List<Object?> get props => [deliveryType];
}

class PlaceOrderEvent extends CheckoutSummaryEvent {
  final String? specialInstructions;
  const PlaceOrderEvent({this.specialInstructions});
  
  @override
  List<Object?> get props => [specialInstructions];
}
