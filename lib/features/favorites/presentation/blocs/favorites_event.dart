import 'package:equatable/equatable.dart';
import '../../../food/domain/entities/restaurant_entity.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

class LoadFavorites extends FavoritesEvent {
  const LoadFavorites();
}

class RefreshFavorites extends FavoritesEvent {
  const RefreshFavorites();
}

class ToggleFavoriteRestaurant extends FavoritesEvent {
  final String restaurantId;
  final RestaurantEntity? restaurant;

  const ToggleFavoriteRestaurant(this.restaurantId, {this.restaurant});

  @override
  List<Object?> get props => [restaurantId, restaurant];
}

class ClearFavoritesActionError extends FavoritesEvent {
  const ClearFavoritesActionError();
}
