import '../../domain/entities/search_result_entity.dart';
import '../../domain/entities/search_sort.dart';

abstract final class SearchResultFilter {
  static SearchResultEntity apply({
    required SearchResultEntity result,
    required SearchFilterSelection filters,
  }) {
    final items = result.items.where((item) {
      if (!_matchesPrice(item.basePrice, filters.priceRange)) return false;
      if (filters.dietary == SearchDietary.vegetarian && item.isVeg != true) {
        return false;
      }
      return true;
    }).toList();

    final restaurants = result.restaurants.where((restaurant) {
      return !filters.rating4Plus || restaurant.ratingAvg >= 4;
    }).toList();

    if (filters.sort == SearchSort.priceLowToHigh) {
      items.sort((a, b) => a.basePrice.compareTo(b.basePrice));
      restaurants.sort((a, b) => a.minOrderAmount.compareTo(b.minOrderAmount));
    } else if (filters.sort == SearchSort.rating) {
      restaurants.sort((a, b) => b.ratingAvg.compareTo(a.ratingAvg));
    } else if (filters.sort == SearchSort.deliveryTime) {
      restaurants.sort(
        (a, b) => a.avgPrepTimeMins.compareTo(b.avgPrepTimeMins),
      );
    }

    return SearchResultEntity(
      categories: result.categories,
      restaurants: restaurants,
      items: items,
    );
  }

  static bool _matchesPrice(double price, SearchPriceRange range) {
    return switch (range) {
      SearchPriceRange.any => true,
      SearchPriceRange.under200 => price <= 200,
      SearchPriceRange.under300 => price <= 300,
      SearchPriceRange.from200to500 => price >= 200 && price <= 500,
      SearchPriceRange.over500 => price >= 500,
    };
  }
}
