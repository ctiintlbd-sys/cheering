import 'package:equatable/equatable.dart';
import '../../../../orders/domain/entities/get_orders_params.dart';

abstract class OrderListEvent extends Equatable {
  const OrderListEvent();

  @override
  List<Object?> get props => [];
}

class LoadOrders extends OrderListEvent {
  final GetOrdersParams params;

  const LoadOrders({required this.params});

  @override
  List<Object?> get props => [params];
}

class RefreshOrders extends OrderListEvent {
  final GetOrdersParams params;

  const RefreshOrders({required this.params});

  @override
  List<Object?> get props => [params];
}
