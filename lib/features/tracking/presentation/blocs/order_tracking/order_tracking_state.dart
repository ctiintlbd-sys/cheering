import 'package:equatable/equatable.dart';

import '../../../domain/entities/order_tracking_entity.dart';

enum OrderTrackingStatus { initial, loading, success, failure }

class OrderTrackingState extends Equatable {
  final OrderTrackingStatus status;
  final OrderTrackingEntity? tracking;
  final String? errorMessage;

  const OrderTrackingState({
    this.status = OrderTrackingStatus.initial,
    this.tracking,
    this.errorMessage,
  });

  OrderTrackingState copyWith({
    OrderTrackingStatus? status,
    OrderTrackingEntity? tracking,
    String? errorMessage,
    bool clearError = false,
  }) {
    return OrderTrackingState(
      status: status ?? this.status,
      tracking: tracking ?? this.tracking,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, tracking, errorMessage];
}
