import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../orders/domain/usecases/get_order_details_usecase.dart';
import '../../../../orders/domain/usecases/cancel_order_usecase.dart';
import 'order_details_event.dart';
import 'order_details_state.dart';

class OrderDetailsBloc extends Bloc<OrderDetailsEvent, OrderDetailsState> {
  final GetOrderDetailsUseCase _getOrderDetailsUseCase;
  final CancelOrderUseCase _cancelOrderUseCase;

  OrderDetailsBloc(
    this._getOrderDetailsUseCase,
    this._cancelOrderUseCase,
  ) : super(const OrderDetailsState()) {
    on<LoadOrderDetails>(_onLoadOrderDetails);
    on<CancelOrder>(_onCancelOrder);
  }

  Future<void> _onLoadOrderDetails(
    LoadOrderDetails event,
    Emitter<OrderDetailsState> emit,
  ) async {
    emit(
      state.copyWith(
        status: OrderDetailsStatus.loading,
        clearError: true,
      ),
    );

    try {
      final orderDetails = await _getOrderDetailsUseCase(event.orderId);
      emit(
        state.copyWith(
          status: OrderDetailsStatus.success,
          orderDetails: orderDetails,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: OrderDetailsStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onCancelOrder(
    CancelOrder event,
    Emitter<OrderDetailsState> emit,
  ) async {
    emit(
      state.copyWith(
        isCancelling: true,
        clearCancelError: true,
      ),
    );

    try {
      await _cancelOrderUseCase(event.orderId, event.reason);
      emit(
        state.copyWith(
          isCancelling: false,
          isCancelSuccess: true,
        ),
      );
      
      // Reload order details to fetch updated status
      add(LoadOrderDetails(orderId: event.orderId));
    } catch (e) {
      emit(
        state.copyWith(
          isCancelling: false,
          cancelErrorMessage: e.toString(),
        ),
      );
    }
  }
}
