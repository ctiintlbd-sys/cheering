import 'package:equatable/equatable.dart';
import '../../../../orders/domain/entities/order_detail_entity.dart';

enum OrderDetailsStatus { initial, loading, success, failure }

class OrderDetailsState extends Equatable {
  final OrderDetailsStatus status;
  final OrderDetailEntity? orderDetails;
  final String? errorMessage;
  final bool isCancelling;
  final bool isCancelSuccess;
  final String? cancelErrorMessage;

  const OrderDetailsState({
    this.status = OrderDetailsStatus.initial,
    this.orderDetails,
    this.errorMessage,
    this.isCancelling = false,
    this.isCancelSuccess = false,
    this.cancelErrorMessage,
  });

  OrderDetailsState copyWith({
    OrderDetailsStatus? status,
    OrderDetailEntity? orderDetails,
    String? errorMessage,
    bool? isCancelling,
    bool? isCancelSuccess,
    String? cancelErrorMessage,
    bool clearError = false,
    bool clearCancelError = false,
  }) {
    return OrderDetailsState(
      status: status ?? this.status,
      orderDetails: orderDetails ?? this.orderDetails,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isCancelling: isCancelling ?? this.isCancelling,
      isCancelSuccess: isCancelSuccess ?? this.isCancelSuccess,
      cancelErrorMessage: clearCancelError
          ? null
          : (cancelErrorMessage ?? this.cancelErrorMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        orderDetails,
        errorMessage,
        isCancelling,
        isCancelSuccess,
        cancelErrorMessage,
      ];
}
