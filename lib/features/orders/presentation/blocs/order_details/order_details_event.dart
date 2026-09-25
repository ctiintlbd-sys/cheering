import 'package:equatable/equatable.dart';

abstract class OrderDetailsEvent extends Equatable {
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

class CancelOrderEvent extends OrderDetailsEvent {
  final String orderId;
  final String reason;

  const CancelOrderEvent({required this.orderId, required this.reason});

  @override
  List<Object?> get props => [orderId, reason];
}
