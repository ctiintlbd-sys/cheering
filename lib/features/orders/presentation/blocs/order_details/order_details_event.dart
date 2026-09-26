import 'package:equatable/equatable.dart';

sealed class OrderDetailsEvent extends Equatable {
  const OrderDetailsEvent();

  @override
  List<Object?> get props => [];
}

class LoadOrderDetails extends OrderDetailsEvent {
  final String orderId;

  const LoadOrderDetails({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class CancelOrder extends OrderDetailsEvent {
  final String orderId;
  final String reason;

  const CancelOrder({required this.orderId, required this.reason});

  @override
  List<Object?> get props => [orderId, reason];
}
