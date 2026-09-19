import 'package:equatable/equatable.dart';
import '../../../../food/domain/entities/restaurant_query_params.dart';

sealed class RestaurantListEvent extends Equatable {
  const RestaurantListEvent();

  @override
  List<Object?> get props => [];
}

class LoadRestaurants extends RestaurantListEvent {
  final RestaurantQueryParams params;

  const LoadRestaurants({required this.params});

  @override
  List<Object?> get props => [params];
}

class RefreshRestaurants extends RestaurantListEvent {
  final RestaurantQueryParams params;

  const RefreshRestaurants({required this.params});

  @override
  List<Object?> get props => [params];
}
