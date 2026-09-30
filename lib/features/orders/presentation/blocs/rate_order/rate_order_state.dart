import 'package:equatable/equatable.dart';

enum RateOrderStatus { initial, loading, success, failure }

class RateOrderState extends Equatable {
  final int restaurantRating;
  final int riderRating;
  final Set<String> selectedTags;
  final String comment;
  final RateOrderStatus status;
  final String? errorMessage;

  const RateOrderState({
    this.restaurantRating = 0,
    this.riderRating = 0,
    this.selectedTags = const {},
    this.comment = '',
    this.status = RateOrderStatus.initial,
    this.errorMessage,
  });

  RateOrderState copyWith({
    int? restaurantRating,
    int? riderRating,
    Set<String>? selectedTags,
    String? comment,
    RateOrderStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return RateOrderState(
      restaurantRating: restaurantRating ?? this.restaurantRating,
      riderRating: riderRating ?? this.riderRating,
      selectedTags: selectedTags ?? this.selectedTags,
      comment: comment ?? this.comment,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        restaurantRating,
        riderRating,
        selectedTags,
        comment,
        status,
        errorMessage,
      ];
}
