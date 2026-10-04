import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../food/domain/entities/restaurant_entity.dart';
import '../../domain/usecases/get_favorites_usecase.dart';
import '../../domain/usecases/toggle_favorite_usecase.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetFavoritesUseCase _getFavoritesUseCase;
  final ToggleFavoriteUseCase _toggleFavoriteUseCase;

  FavoritesBloc(
    this._getFavoritesUseCase,
    this._toggleFavoriteUseCase,
  ) : super(const FavoritesState()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<RefreshFavorites>(_onRefreshFavorites);
    on<ToggleFavoriteRestaurant>(_onToggleFavoriteRestaurant);
    on<ClearFavoritesActionError>(_onClearActionError);
  }

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(state.copyWith(status: FavoritesStatus.loading, clearError: true));
    try {
      await emit.forEach<List<RestaurantEntity>>(
        _getFavoritesUseCase(),
        onData: (favorites) {
          final favoriteIds = favorites.map((r) => r.id).toSet();
          return state.copyWith(
            status: FavoritesStatus.success,
            favorites: favorites,
            favoriteIds: favoriteIds,
            clearError: true,
          );
        },
        onError: (error, _) => state.copyWith(
          status: FavoritesStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: FavoritesStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onRefreshFavorites(
    RefreshFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      await emit.forEach<List<RestaurantEntity>>(
        _getFavoritesUseCase(),
        onData: (favorites) {
          final favoriteIds = favorites.map((r) => r.id).toSet();
          return state.copyWith(
            status: FavoritesStatus.success,
            favorites: favorites,
            favoriteIds: favoriteIds,
          );
        },
        onError: (error, _) => state.copyWith(
          status: FavoritesStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: FavoritesStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onToggleFavoriteRestaurant(
    ToggleFavoriteRestaurant event,
    Emitter<FavoritesState> emit,
  ) async {
    final restaurantId = event.restaurantId;
    final isCurrentlyFavorite = state.isFavorite(restaurantId);
    final previousFavorites = state.favorites;
    final previousFavoriteIds = Set<String>.from(state.favoriteIds);

    // ⚡️ Optimistic Update: Instantly toggle favorite state without any loading spinner!
    final updatedFavoriteIds = Set<String>.from(previousFavoriteIds);
    List<RestaurantEntity> updatedFavorites;

    if (isCurrentlyFavorite) {
      updatedFavoriteIds.remove(restaurantId);
      updatedFavorites = previousFavorites
          .where((r) => r.id != restaurantId)
          .toList();
    } else {
      updatedFavoriteIds.add(restaurantId);
      if (event.restaurant != null) {
        updatedFavorites = [
          event.restaurant!.copyWith(isFavorite: true),
          ...previousFavorites,
        ];
      } else {
        updatedFavorites = previousFavorites;
      }
    }

    // Immediately emit optimistic update
    emit(
      state.copyWith(
        favorites: updatedFavorites,
        favoriteIds: updatedFavoriteIds,
        clearActionError: true,
      ),
    );

    // Call API in the background
    try {
      final result = await _toggleFavoriteUseCase(restaurantId);

      // Harmonize with backend confirmed state
      final serverFavoriteIds = Set<String>.from(state.favoriteIds);
      if (result.isFavorite) {
        serverFavoriteIds.add(result.restaurantId);
      } else {
        serverFavoriteIds.remove(result.restaurantId);
      }

      emit(state.copyWith(favoriteIds: serverFavoriteIds));
    } catch (e) {
      // Revert to previous state if API call fails
      emit(
        state.copyWith(
          favorites: previousFavorites,
          favoriteIds: previousFavoriteIds,
          actionErrorMessage: e.toString(),
        ),
      );
    }
  }

  void _onClearActionError(
    ClearFavoritesActionError event,
    Emitter<FavoritesState> emit,
  ) {
    emit(state.copyWith(clearActionError: true));
  }
}
