import 'package:equatable/equatable.dart';
import '../../../domain/entities/checkout_summary_entity.dart';
import '../../../domain/entities/checkout_summary_params.dart';

enum CheckoutSummaryStatus { initial, loading, success, failure }

class CheckoutSummaryState extends Equatable {
  final CheckoutSummaryStatus status;
  final CheckoutSummaryEntity? summary;
  final String? errorMessage;
  final CheckoutSummaryParams? currentParams;
  final String paymentMethod;

  const CheckoutSummaryState({
    this.status = CheckoutSummaryStatus.initial,
    this.summary,
    this.errorMessage,
    this.currentParams,
    this.paymentMethod = 'COD',
  });

  CheckoutSummaryState copyWith({
    CheckoutSummaryStatus? status,
    CheckoutSummaryEntity? summary,
    String? errorMessage,
    CheckoutSummaryParams? currentParams,
    String? paymentMethod,
    bool clearError = false,
  }) {
    return CheckoutSummaryState(
      status: status ?? this.status,
      summary: summary ?? this.summary,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      currentParams: currentParams ?? this.currentParams,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }

  @override
  List<Object?> get props => [status, summary, errorMessage, currentParams, paymentMethod];
}
