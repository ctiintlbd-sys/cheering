import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_order_tracking_usecase.dart';
import 'order_tracking_event.dart';
import 'order_tracking_state.dart';

class OrderTrackingBloc extends Bloc<OrderTrackingEvent, OrderTrackingState> {
  final GetOrderTrackingUseCase _getOrderTrackingUseCase;

  OrderTrackingBloc(this._getOrderTrackingUseCase)
      : super(const OrderTrackingState()) {
    on<LoadOrderTracking>(_onLoadOrderTracking);
  }

  Future<void> _onLoadOrderTracking(
    LoadOrderTracking event,
    Emitter<OrderTrackingState> emit,
  ) async {
    emit(
      state.copyWith(
        status: OrderTrackingStatus.loading,
        clearError: true,
      ),
    );

    try {
      final tracking = await _getOrderTrackingUseCase(event.orderId);
      emit(
        state.copyWith(
          status: OrderTrackingStatus.success,
          tracking: tracking,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: OrderTrackingStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
