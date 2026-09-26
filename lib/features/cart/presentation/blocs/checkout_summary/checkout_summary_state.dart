import 'package:equatable/equatable.dart';
import '../../../domain/entities/checkout_summary_entity.dart';
import '../../../domain/entities/checkout_summary_params.dart';

enum CheckoutSummaryStatus { initial, loading, success, failure }

class CheckoutSummaryState extends Equatable {
  final CheckoutSummaryStatus status;
  final CheckoutSummaryEntity? summary;
  final String? errorMessage;
  final CheckoutSummaryParams? currentParams;
  final String paymentMethod;
  final bool isPlacingOrder;
  final bool orderPlacedSuccess;
  final String? placeOrderErrorMessage;
  final String? placedOrderId;
  final String? placedOrderUuid;
  final String? placedRestaurantName;

  const CheckoutSummaryState({
    this.status = CheckoutSummaryStatus.initial,
    this.summary,
    this.errorMessage,
    this.currentParams,
    this.paymentMethod = 'COD',
    this.isPlacingOrder = false,
    this.orderPlacedSuccess = false,
    this.placeOrderErrorMessage,
    this.placedOrderId,
    this.placedOrderUuid,
    this.placedRestaurantName,
  });

  CheckoutSummaryState copyWith({
    CheckoutSummaryStatus? status,
    CheckoutSummaryEntity? summary,
    String? errorMessage,
    CheckoutSummaryParams? currentParams,
    String? paymentMethod,
    bool? isPlacingOrder,
    bool? orderPlacedSuccess,
    String? placeOrderErrorMessage,
    String? placedOrderId,
    String? placedOrderUuid,
    String? placedRestaurantName,
    bool clearError = false,
    bool clearPlaceOrderError = false,
  }) {
    return CheckoutSummaryState(
      status: status ?? this.status,
      summary: summary ?? this.summary,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      currentParams: currentParams ?? this.currentParams,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isPlacingOrder: isPlacingOrder ?? this.isPlacingOrder,
      orderPlacedSuccess: orderPlacedSuccess ?? this.orderPlacedSuccess,
      placeOrderErrorMessage: clearPlaceOrderError
          ? null
          : (placeOrderErrorMessage ?? this.placeOrderErrorMessage),
      placedOrderId: placedOrderId ?? this.placedOrderId,
      placedOrderUuid: placedOrderUuid ?? this.placedOrderUuid,
      placedRestaurantName: placedRestaurantName ?? this.placedRestaurantName,
    );
  }

  @override
  List<Object?> get props => [
        status,
        summary,
        errorMessage,
        currentParams,
        paymentMethod,
        isPlacingOrder,
        orderPlacedSuccess,
        placeOrderErrorMessage,
        placedOrderId,
        placedOrderUuid,
        placedRestaurantName,
      ];
}
