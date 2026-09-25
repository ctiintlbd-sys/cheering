import 'package:equatable/equatable.dart';
import '../../../../orders/domain/entities/order_entity.dart';
import '../../../../orders/domain/entities/get_orders_params.dart';

enum OrderListStatus { initial, loading, success, failure }

class OrderListState extends Equatable {
  final OrderListStatus status;
  final List<OrderEntity> orders;
  final String? errorMessage;
  final GetOrdersParams? baseParams;
  final GetOrdersParams? currentParams;

  const OrderListState({
    this.status = OrderListStatus.initial,
    this.orders = const [],
    this.errorMessage,
    this.baseParams,
    this.currentParams,
  });

  OrderListState copyWith({
    OrderListStatus? status,
    List<OrderEntity>? orders,
    String? errorMessage,
    GetOrdersParams? baseParams,
    GetOrdersParams? currentParams,
    bool clearError = false,
  }) {
    return OrderListState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      baseParams: baseParams ?? this.baseParams,
      currentParams: currentParams ?? this.currentParams,
    );
  }

  @override
  List<Object?> get props => [
        status,
        orders,
        errorMessage,
        baseParams,
        currentParams,
      ];
}
