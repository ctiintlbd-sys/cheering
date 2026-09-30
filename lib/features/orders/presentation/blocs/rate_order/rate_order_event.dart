import 'package:equatable/equatable.dart';

sealed class RateOrderEvent extends Equatable {
  const RateOrderEvent();

  @override
  List<Object?> get props => [];
}

class UpdateRestaurantRating extends RateOrderEvent {
  final int rating;

  const UpdateRestaurantRating(this.rating);

  @override
  List<Object?> get props => [rating];
}

class UpdateRiderRating extends RateOrderEvent {
  final int rating;

  const UpdateRiderRating(this.rating);

  @override
  List<Object?> get props => [rating];
}

class ToggleTag extends RateOrderEvent {
  final String tag;

  const ToggleTag(this.tag);

  @override
  List<Object?> get props => [tag];
}

class UpdateComment extends RateOrderEvent {
  final String comment;

  const UpdateComment(this.comment);

  @override
  List<Object?> get props => [comment];
}

class SubmitRateOrder extends RateOrderEvent {
  final String orderId;
  final bool hasRider;

  const SubmitRateOrder({
    required this.orderId,
    this.hasRider = false,
  });

  @override
  List<Object?> get props => [orderId, hasRider];
}
