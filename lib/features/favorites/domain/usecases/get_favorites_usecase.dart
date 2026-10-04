import '../../../food/domain/entities/restaurant_entity.dart';
import '../repositories/i_favorites_repository.dart';

class GetFavoritesUseCase {
  final IFavoritesRepository _repository;

  GetFavoritesUseCase(this._repository);

  Stream<List<RestaurantEntity>> call() {
    return _repository.getFavorites();
  }
}
