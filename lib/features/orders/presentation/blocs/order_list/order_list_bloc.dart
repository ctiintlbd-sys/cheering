import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../orders/domain/entities/order_entity.dart';
import '../../../../orders/domain/usecases/get_orders_usecase.dart';
import 'order_list_event.dart';
import 'order_list_state.dart';

class OrderListBloc extends Bloc<OrderListEvent, OrderListState> {
  final GetOrdersUseCase _getOrdersUseCase;

  OrderListBloc(this._getOrdersUseCase) : super(const OrderListState()) {
    on<LoadOrders>(_onLoadOrders);
    on<RefreshOrders>(_onRefreshOrders);
  }

  Future<void> _onLoadOrders(
    LoadOrders event,
    Emitter<OrderListState> emit,
  ) async {
    emit(
      state.copyWith(
        status: OrderListStatus.loading,
        baseParams: event.params,
        currentParams: event.params,
        clearError: true,
      ),
    );

    try {
      await emit.forEach<List<OrderEntity>>(
        _getOrdersUseCase(event.params),
        onData: (orders) => state.copyWith(
          status: OrderListStatus.success,
          orders: orders,
          baseParams: event.params,
          currentParams: event.params,
        ),
        onError: (error, _) => state.copyWith(
          status: OrderListStatus.failure,
          orders: const [],
          errorMessage: error.toString(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: OrderListStatus.failure,
          orders: const [],
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onRefreshOrders(
    RefreshOrders event,
    Emitter<OrderListState> emit,
  ) async {
    try {
      await emit.forEach<List<OrderEntity>>(
        _getOrdersUseCase(event.params),
        onData: (orders) => state.copyWith(
          status: OrderListStatus.success,
          orders: orders,
          currentParams: event.params,
        ),
        onError: (error, _) => state.copyWith(
          status: OrderListStatus.failure,
          orders: const [],
          errorMessage: error.toString(),
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        status: OrderListStatus.failure,
        orders: const [],
        errorMessage: e.toString(),
      ));
    }
  }
}
