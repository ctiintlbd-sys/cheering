import '../entities/favorite_toggle_entity.dart';
import '../repositories/i_favorites_repository.dart';

class ToggleFavoriteUseCase {
  final IFavoritesRepository _repository;

  ToggleFavoriteUseCase(this._repository);

  Future<FavoriteToggleEntity> call(String restaurantId) {
    return _repository.toggleFavorite(restaurantId);
  }
}
