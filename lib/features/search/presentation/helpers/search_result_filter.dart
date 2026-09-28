import '../../../food/domain/entities/category_entity.dart';
import '../../../food/domain/entities/menu_entity.dart';
import '../../../food/domain/entities/restaurant_entity.dart';
import '../../domain/entities/search_result_entity.dart';
import '../../domain/entities/search_sort.dart';

class FilteredSearchResults {
  const FilteredSearchResults({
    required this.categories,
    required this.restaurants,
    required this.items,
  });

  final List<CategoryEntity> categories;
  final List<RestaurantEntity> restaurants;
  final List<MenuItemEntity> items;

  int get totalCount => categories.length + restaurants.length + items.length;

  bool get isEmpty => totalCount == 0;
}

abstract final class SearchResultFilter {
  static final _nonVeg = RegExp(
    r'\b(chicken|beef|mutton|fish|prawn|shrimp|meat|kacchi|tehari)\b',
    caseSensitive: false,
  );
  static final _healthy = RegExp(
    r'\b(salad|grilled|steamed|boiled|yogurt|healthy|veggie|vegetable)\b',
    caseSensitive: false,
  );
  static final _spicy = RegExp(
    r'\b(spicy|chilli|chili|pepper|jhal|masala|hot)\b',
    caseSensitive: false,
  );

  static FilteredSearchResults apply({
    required SearchResultEntity? result,
    required SearchFilterSelection selection,
  }) {
    if (result == null) {
      return const FilteredSearchResults(
        categories: [],
        restaurants: [],
        items: [],
      );
    }

    final restaurantById = {
      for (final restaurant in result.restaurants) restaurant.id: restaurant,
    };

    var items = result.items.where((item) {
      if (!_matchesPrice(item.basePrice, selection)) return false;
      if (!_matchesDietary(item, selection.dietary)) return false;
      if (selection.rating4Plus) {
        final restaurant = item.restaurantId == null
            ? null
            : restaurantById[item.restaurantId];
        if (restaurant != null && restaurant.ratingAvg < 4) return false;
      }
      return true;
    }).toList();

    var restaurants = result.restaurants.where((restaurant) {
      if (selection.rating4Plus && restaurant.ratingAvg < 4) return false;
      return true;
    }).toList();

    _sortRestaurants(restaurants, selection.sort);
    _sortItems(items, selection.sort);

    return FilteredSearchResults(
      categories: result.categories,
      restaurants: restaurants,
      items: items,
    );
  }

  static int count({
    required SearchResultEntity? result,
    required SearchFilterSelection selection,
  }) {
    return apply(result: result, selection: selection).totalCount;
  }

  static bool hasVisibleResults({
    required SearchResultEntity? result,
    required SearchFilterSelection selection,
  }) {
    return !apply(result: result, selection: selection).isEmpty;
  }

  static bool _matchesPrice(double price, SearchFilterSelection selection) {
    switch (selection.priceRange) {
      case SearchPriceRange.under200:
        return price <= 200;
      case SearchPriceRange.from200to500:
        return price >= 200 && price <= 500;
      case SearchPriceRange.over500:
        return price >= 500;
      case SearchPriceRange.any:
        return !selection.under300 || price <= 300;
    }
  }

  static bool _matchesDietary(MenuItemEntity item, SearchDietary dietary) {
    final text = '${item.name} ${item.description ?? ''}';
    return switch (dietary) {
      SearchDietary.any => true,
      SearchDietary.vegetarian =>
        item.isVeg == true ||
            (item.isVeg != false && !_nonVeg.hasMatch(text)),
      SearchDietary.healthy => _healthy.hasMatch(text),
      SearchDietary.spicy => _spicy.hasMatch(text),
    };
  }

  static void _sortRestaurants(
    List<RestaurantEntity> restaurants,
    SearchSort sort,
  ) {
    switch (sort) {
      case SearchSort.rating:
        restaurants.sort((a, b) => b.ratingAvg.compareTo(a.ratingAvg));
      case SearchSort.deliveryTime:
        restaurants.sort(
          (a, b) => a.avgPrepTimeMins.compareTo(b.avgPrepTimeMins),
        );
      case SearchSort.priceLowToHigh:
        restaurants.sort((a, b) => a.minOrderAmount.compareTo(b.minOrderAmount));
      case SearchSort.relevance:
        break;
    }
  }

  static void _sortItems(List<MenuItemEntity> items, SearchSort sort) {
    if (sort == SearchSort.priceLowToHigh) {
      items.sort((a, b) => a.basePrice.compareTo(b.basePrice));
    }
  }
}
