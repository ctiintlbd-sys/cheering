import '../../../food/domain/entities/menu_entity.dart';
import '../../../food/domain/entities/restaurant_entity.dart';
import '../../domain/entities/search_result_entity.dart';
import '../../domain/entities/search_sort.dart';

abstract final class SearchResultFilter {
  static List<RestaurantEntity> restaurants({
    required List<RestaurantEntity> restaurants,
    required SearchSort sort,
    bool rating4Plus = false,
  }) {
    var list = List<RestaurantEntity>.from(restaurants);
    if (rating4Plus) {
      list = list.where((restaurant) => restaurant.ratingAvg >= 4).toList();
    }
    if (sort == SearchSort.rating) {
      list.sort((a, b) => b.ratingAvg.compareTo(a.ratingAvg));
    } else if (sort == SearchSort.deliveryTime) {
      list.sort((a, b) => a.avgPrepTimeMins.compareTo(b.avgPrepTimeMins));
    }
    return list;
  }

  static List<MenuItemEntity> items({
    required List<MenuItemEntity> items,
    required SearchSort sort,
    required SearchPriceRange priceRange,
    required SearchDietary dietary,
    bool under300 = false,
  }) {
    var list = items.where((item) {
      if (!_matchesPrice(item.basePrice, priceRange, under300)) return false;
      return _matchesDietary(item, dietary);
    }).toList();

    if (sort == SearchSort.priceLowToHigh) {
      list.sort((a, b) => a.basePrice.compareTo(b.basePrice));
    }
    return list;
  }

  static int count({
    required SearchResultEntity? result,
    required SearchFilterSelection selection,
  }) {
    if (result == null) return 0;
    return result.categories.length +
        restaurants(
          restaurants: result.restaurants,
          sort: selection.sort,
          rating4Plus: selection.rating4Plus,
        ).length +
        items(
          items: result.items,
          sort: selection.sort,
          priceRange: selection.priceRange,
          dietary: selection.dietary,
          under300: selection.under300,
        ).length;
  }

  static bool hasVisibleResults({
    required SearchResultEntity? result,
    required SearchFilterSelection selection,
  }) {
    return count(result: result, selection: selection) > 0;
  }

  static bool _matchesPrice(
    double price,
    SearchPriceRange priceRange,
    bool under300,
  ) {
    switch (priceRange) {
      case SearchPriceRange.under200:
        return price <= 200;
      case SearchPriceRange.from200to500:
        return price >= 200 && price <= 500;
      case SearchPriceRange.over500:
        return price >= 500;
      case SearchPriceRange.any:
        return !under300 || price <= 300;
    }
  }

  static bool _matchesDietary(MenuItemEntity item, SearchDietary dietary) {
    return switch (dietary) {
      SearchDietary.any => true,
      SearchDietary.vegetarian => item.isVeg == true,
      SearchDietary.healthy => true,
      SearchDietary.spicy => true,
    };
  }
}
