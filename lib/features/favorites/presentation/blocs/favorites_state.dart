import 'package:equatable/equatable.dart';
import '../../../food/domain/entities/restaurant_entity.dart';

enum FavoritesStatus { initial, loading, success, failure }

class FavoritesState extends Equatable {
  final FavoritesStatus status;
  final List<RestaurantEntity> favorites;
  final String? errorMessage;
  final Set<String> favoriteIds;
  final String? actionErrorMessage;

  const FavoritesState({
    this.status = FavoritesStatus.initial,
    this.favorites = const [],
    this.errorMessage,
    this.favoriteIds = const {},
    this.actionErrorMessage,
  });

  bool isFavorite(String restaurantId, {bool fallback = false}) {
    if (status == FavoritesStatus.success || favoriteIds.isNotEmpty) {
      return favoriteIds.contains(restaurantId);
    }
    return fallback;
  }

  FavoritesState copyWith({
    FavoritesStatus? status,
    List<RestaurantEntity>? favorites,
    String? errorMessage,
    Set<String>? favoriteIds,
    String? actionErrorMessage,
    bool clearError = false,
    bool clearActionError = false,
  }) {
    return FavoritesState(
      status: status ?? this.status,
      favorites: favorites ?? this.favorites,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      favoriteIds: favoriteIds ?? this.favoriteIds,
      actionErrorMessage: clearActionError
          ? null
          : (actionErrorMessage ?? this.actionErrorMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    favorites,
    errorMessage,
    favoriteIds,
    actionErrorMessage,
  ];
}
