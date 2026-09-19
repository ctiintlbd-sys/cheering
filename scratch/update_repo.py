import os

with open('lib/features/food/domain/repositories/i_food_repository.dart', 'r') as f:
    content = f.read()

content = content.replace("Future<HomeFeedEntity> getHomeFeed", "Stream<HomeFeedEntity> getHomeFeed")
content = content.replace("Future<List<RestaurantEntity>> getRestaurants", "Stream<List<RestaurantEntity>> getRestaurants")
content = content.replace("Future<List<CategoryEntity>> getCategories", "Stream<List<CategoryEntity>> getCategories")

with open('lib/features/food/domain/repositories/i_food_repository.dart', 'w') as f:
    f.write(content)

# Update use cases
with open('lib/features/food/domain/usecases/get_home_feed_usecase.dart', 'r') as f:
    content = f.read()
content = content.replace("Future<HomeFeedEntity> call", "Stream<HomeFeedEntity> call")
with open('lib/features/food/domain/usecases/get_home_feed_usecase.dart', 'w') as f:
    f.write(content)

with open('lib/features/food/domain/usecases/get_restaurants_usecase.dart', 'r') as f:
    content = f.read()
content = content.replace("Future<List<RestaurantEntity>> call", "Stream<List<RestaurantEntity>> call")
with open('lib/features/food/domain/usecases/get_restaurants_usecase.dart', 'w') as f:
    f.write(content)

with open('lib/features/food/domain/usecases/get_categories_usecase.dart', 'r') as f:
    content = f.read()
content = content.replace("Future<List<CategoryEntity>> call", "Stream<List<CategoryEntity>> call")
with open('lib/features/food/domain/usecases/get_categories_usecase.dart', 'w') as f:
    f.write(content)
