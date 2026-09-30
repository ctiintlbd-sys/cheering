import 'package:equatable/equatable.dart';

class SubmitReviewParams extends Equatable {
  final String orderId;
  final int restaurantRating;
  final int? riderRating;
  final String? comment;

  const SubmitReviewParams({
    required this.orderId,
    required this.restaurantRating,
    this.riderRating,
    this.comment,
  });

  Map<String, dynamic> toMap() {
    return {
      'restaurant_rating': restaurantRating,
      if (riderRating != null) 'rider_rating': riderRating,
      if (comment != null && comment!.trim().isNotEmpty)
        'comment': comment!.trim(),
    };
  }

  @override
  List<Object?> get props => [
        orderId,
        restaurantRating,
        riderRating,
        comment,
      ];
}
