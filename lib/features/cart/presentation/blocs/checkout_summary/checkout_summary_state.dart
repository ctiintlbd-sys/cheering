import 'package:equatable/equatable.dart';
import '../../../domain/entities/checkout_summary_entity.dart';
import '../../../domain/entities/checkout_summary_params.dart';

enum CheckoutSummaryStatus { initial, loading, success, failure }

class CheckoutSummaryState extends Equatable {
  final CheckoutSummaryStatus status;
  final CheckoutSummaryEntity? summary;
  final String? errorMessage;
  
  // Keep track of current params to easily modify them (like adding a tip later)
  final CheckoutSummaryParams? currentParams;

  const CheckoutSummaryState({
    this.status = CheckoutSummaryStatus.initial,
    this.summary,
    this.errorMessage,
    this.currentParams,
  });

  CheckoutSummaryState copyWith({
    CheckoutSummaryStatus? status,
    CheckoutSummaryEntity? summary,
    String? errorMessage,
    CheckoutSummaryParams? currentParams,
    bool clearError = false,
  }) {
    return CheckoutSummaryState(
      status: status ?? this.status,
      summary: summary ?? this.summary,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      currentParams: currentParams ?? this.currentParams,
    );
  }

  @override
  List<Object?> get props => [status, summary, errorMessage, currentParams];
}
