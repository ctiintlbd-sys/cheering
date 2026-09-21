import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/checkout_summary_entity.dart';
import '../../../domain/entities/checkout_summary_params.dart';
import '../../../domain/usecases/get_checkout_summary_usecase.dart';
import 'checkout_summary_event.dart';
import 'checkout_summary_state.dart';

class CheckoutSummaryBloc
    extends Bloc<CheckoutSummaryEvent, CheckoutSummaryState> {
  final GetCheckoutSummaryUseCase _getCheckoutSummaryUseCase;

  CheckoutSummaryBloc(this._getCheckoutSummaryUseCase)
      : super(const CheckoutSummaryState()) {
    on<LoadCheckoutSummary>(_onLoadCheckoutSummary);
    on<ApplyPromoCodeEvent>(_onApplyPromoCode);
    on<UpdateTipEvent>(_onUpdateTip);
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
}
