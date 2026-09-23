import 'package:equatable/equatable.dart';
import '../../../../food/domain/entities/restaurant_entity.dart';

sealed class RestaurantDetailsEvent extends Equatable {
  const RestaurantDetailsEvent();

  @override
  List<Object?> get props => [];
}

class LoadRestaurantDetails extends RestaurantDetailsEvent {
  final String? id;
  final RestaurantEntity? restaurant;

  const LoadRestaurantDetails({this.id, this.restaurant})
      : assert(id != null || restaurant != null, 'Either id or restaurant must be provided');

  @override
  List<Object?> get props => [id, restaurant];
}
