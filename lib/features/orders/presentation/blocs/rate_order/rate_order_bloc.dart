import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/submit_review_params.dart';
import '../../../domain/usecases/submit_review_usecase.dart';
import 'rate_order_event.dart';
import 'rate_order_state.dart';

class RateOrderBloc extends Bloc<RateOrderEvent, RateOrderState> {
  final SubmitReviewUseCase _submitReviewUseCase;

  RateOrderBloc(this._submitReviewUseCase) : super(const RateOrderState()) {
    on<UpdateRestaurantRating>(_onUpdateRestaurantRating);
    on<UpdateRiderRating>(_onUpdateRiderRating);
    on<ToggleTag>(_onToggleTag);
    on<UpdateComment>(_onUpdateComment);
    on<SubmitRateOrder>(_onSubmitRateOrder);
  }

  void _onUpdateRestaurantRating(
    UpdateRestaurantRating event,
    Emitter<RateOrderState> emit,
  ) {
    emit(state.copyWith(restaurantRating: event.rating, clearError: true));
  }

  void _onUpdateRiderRating(
    UpdateRiderRating event,
    Emitter<RateOrderState> emit,
  ) {
    emit(state.copyWith(riderRating: event.rating, clearError: true));
  }

  void _onToggleTag(
    ToggleTag event,
    Emitter<RateOrderState> emit,
  ) {
    final currentTags = Set<String>.from(state.selectedTags);
    if (currentTags.contains(event.tag)) {
      currentTags.remove(event.tag);
    } else {
      currentTags.add(event.tag);
    }
    emit(state.copyWith(selectedTags: currentTags, clearError: true));
  }

  void _onUpdateComment(
    UpdateComment event,
    Emitter<RateOrderState> emit,
  ) {
    emit(state.copyWith(comment: event.comment, clearError: true));
  }

  Future<void> _onSubmitRateOrder(
    SubmitRateOrder event,
    Emitter<RateOrderState> emit,
  ) async {
    if (state.restaurantRating == 0) {
      emit(
        state.copyWith(
          status: RateOrderStatus.failure,
          errorMessage: 'Please select a rating for the restaurant',
        ),
      );
      return;
    }

    if (event.hasRider && state.riderRating == 0) {
      emit(
        state.copyWith(
          status: RateOrderStatus.failure,
          errorMessage: 'Please select a rating for the rider',
        ),
      );
      return;
    }

    emit(state.copyWith(status: RateOrderStatus.loading, clearError: true));

    try {
      final trimmedComment = state.comment.trim();
      await _submitReviewUseCase(
        SubmitReviewParams(
          orderId: event.orderId,
          restaurantRating: state.restaurantRating,
          riderRating: event.hasRider ? state.riderRating : null,
          comment: trimmedComment.isEmpty ? null : trimmedComment,
        ),
      );
      emit(state.copyWith(status: RateOrderStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: RateOrderStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
