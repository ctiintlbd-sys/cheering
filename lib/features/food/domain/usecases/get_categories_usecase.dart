import '../repositories/i_food_repository.dart';
import '../entities/category_entity.dart';

class GetCategoriesUseCase {
  final IFoodRepository _repository;

  GetCategoriesUseCase(this._repository);

  Stream<List<CategoryEntity>> call() {
    return _repository.getCategories();
  }
}
