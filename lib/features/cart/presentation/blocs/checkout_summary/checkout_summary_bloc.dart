import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../orders/domain/usecases/create_order_usecase.dart';
import '../../../../orders/domain/entities/create_order_params.dart';
import '../../../domain/entities/checkout_summary_entity.dart';
import '../../../domain/entities/checkout_summary_params.dart';
import '../../../domain/usecases/get_checkout_summary_usecase.dart';
import 'checkout_summary_event.dart';
import 'checkout_summary_state.dart';

class CheckoutSummaryBloc
    extends Bloc<CheckoutSummaryEvent, CheckoutSummaryState> {
  final GetCheckoutSummaryUseCase _getCheckoutSummaryUseCase;
  final CreateOrderUseCase _createOrderUseCase;

  CheckoutSummaryBloc(
    this._getCheckoutSummaryUseCase,
    this._createOrderUseCase,
  ) : super(const CheckoutSummaryState()) {
    on<LoadCheckoutSummary>(_onLoadCheckoutSummary);
    on<ApplyPromoCodeEvent>(_onApplyPromoCode);
    on<UpdateTipEvent>(_onUpdateTip);
    on<UpdatePaymentMethodEvent>(_onUpdatePaymentMethod);
    on<PlaceOrderEvent>(_onPlaceOrder);
  }

  Future<void> _onLoadCheckoutSummary(
    LoadCheckoutSummary event,
    Emitter<CheckoutSummaryState> emit,
  ) async {
    emit(
      state.copyWith(
        status: CheckoutSummaryStatus.loading,
        currentParams: event.params,
        clearError: true,
      ),
    );

    try {
      await emit.forEach<CheckoutSummaryEntity>(
        _getCheckoutSummaryUseCase(event.params),
        onData: (summary) => state.copyWith(
          status: CheckoutSummaryStatus.success,
          summary: summary,
          clearError: true,
        ),
        onError: (error, _) => state.copyWith(
          status: CheckoutSummaryStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CheckoutSummaryStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onApplyPromoCode(
    ApplyPromoCodeEvent event,
    Emitter<CheckoutSummaryState> emit,
  ) {
    if (state.currentParams == null) return;

    final newParams = CheckoutSummaryParams(
      addressId: state.currentParams!.addressId,
      promoCode: event.promoCode,
      tip: state.currentParams!.tip,
    );

    add(LoadCheckoutSummary(newParams));
  }

  void _onUpdateTip(
    UpdateTipEvent event,
    Emitter<CheckoutSummaryState> emit,
  ) {
    if (state.currentParams == null) return;

    final newParams = CheckoutSummaryParams(
      addressId: state.currentParams!.addressId,
      promoCode: state.currentParams!.promoCode,
      tip: event.tip,
    );

    add(LoadCheckoutSummary(newParams));
  }

  void _onUpdatePaymentMethod(
    UpdatePaymentMethodEvent event,
    Emitter<CheckoutSummaryState> emit,
  ) {
    emit(state.copyWith(paymentMethod: event.paymentMethod));
  }

  Future<void> _onPlaceOrder(
    PlaceOrderEvent event,
    Emitter<CheckoutSummaryState> emit,
  ) async {
    if (state.currentParams == null) return;

    emit(state.copyWith(
      isPlacingOrder: true,
      clearPlaceOrderError: true,
    ));

    try {
      final params = CreateOrderParams(
        paymentMethod: state.paymentMethod,
        addressId: state.currentParams!.addressId,
        promoCode: state.currentParams!.promoCode,
        tip: state.currentParams!.tip,
        specialInstructions: event.specialInstructions,
      );

      final order = await _createOrderUseCase(params);

      emit(state.copyWith(
        isPlacingOrder: false,
        orderPlacedSuccess: true,
        placedOrderId: order.orderNumber > 0
            ? '#${order.orderNumber}'
            : (order.id.isNotEmpty ? order.id : null),
        placedRestaurantName:
            order.restaurantName.isNotEmpty ? order.restaurantName : null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isPlacingOrder: false,
        placeOrderErrorMessage: e.toString(),
      ));
    }
  }
}
