import 'package:equatable/equatable.dart';

sealed class RestaurantDetailsEvent extends Equatable {
  const RestaurantDetailsEvent();

  @override
  List<Object?> get props => [];
}

class LoadRestaurantDetails extends RestaurantDetailsEvent {
  final String restaurantId;
  final double? lat;
  final double? lng;

  const LoadRestaurantDetails({required this.restaurantId, this.lat, this.lng});

  @override
  List<Object?> get props => [restaurantId, lat, lng];
}
