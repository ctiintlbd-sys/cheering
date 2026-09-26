import 'package:equatable/equatable.dart';

sealed class OrderTrackingEvent extends Equatable {
  const OrderTrackingEvent();

  @override
  List<Object?> get props => [];
}

class LoadOrderTracking extends OrderTrackingEvent {
  final String orderId;

  const LoadOrderTracking(this.orderId);

  @override
  List<Object?> get props => [orderId];
}
