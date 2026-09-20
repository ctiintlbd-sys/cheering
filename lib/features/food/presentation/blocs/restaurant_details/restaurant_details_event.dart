import 'package:equatable/equatable.dart';
import '../../../../food/domain/entities/restaurant_entity.dart';

sealed class RestaurantDetailsEvent extends Equatable {
  const RestaurantDetailsEvent();

  @override
  List<Object?> get props => [];
}

class LoadRestaurantDetails extends RestaurantDetailsEvent {
  final RestaurantEntity restaurant;

  const LoadRestaurantDetails({required this.restaurant});

  @override
  List<Object?> get props => [restaurant];
}
