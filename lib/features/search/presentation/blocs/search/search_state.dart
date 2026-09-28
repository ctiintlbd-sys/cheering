import 'package:equatable/equatable.dart';

import '../../../../food/domain/entities/category_entity.dart';
import '../../../../food/domain/entities/menu_entity.dart';
import '../../../../food/domain/entities/restaurant_entity.dart';
import '../../../domain/entities/search_result_entity.dart';
import '../../../domain/entities/search_sort.dart';

enum SearchStatus { initial, loading, success, failure }

class SearchState extends Equatable {
  const SearchState({
    this.status = SearchStatus.initial,
    this.result,
    this.errorMessage,
    this.query = '',
    this.recentSearches = const [],
    this.sort = SearchSort.relevance,
    this.priceRange = SearchPriceRange.any,
    this.dietary = SearchDietary.any,
    this.under300 = false,
    this.rating4Plus = false,
  });

  final SearchStatus status;
  final SearchResultEntity? result;
  final String? errorMessage;
  final String query;
  final List<String> recentSearches;
  final SearchSort sort;
  final SearchPriceRange priceRange;
  final SearchDietary dietary;
  final bool under300;
  final bool rating4Plus;

  bool get isIdle => query.trim().isEmpty;

  SearchFilterSelection get filterSelection => SearchFilterSelection(
    sort: sort,
    priceRange: priceRange,
    dietary: dietary,
  );

  List<CategoryEntity> get visibleCategories => result?.categories ?? const [];

  List<RestaurantEntity> get visibleRestaurants => filterRestaurants(
    restaurants: result?.restaurants ?? const [],
    sort: sort,
    rating4Plus: rating4Plus,
  );

  List<MenuItemEntity> get visibleItems => filterItems(
    items: result?.items ?? const [],
    sort: sort,
    priceRange: priceRange,
    dietary: dietary,
    under300: under300,
  );

  int get visibleResultCount =>
      visibleCategories.length +
      visibleRestaurants.length +
      visibleItems.length;

  bool get hasVisibleResults => visibleResultCount > 0;

  SearchState copyWith({
    SearchStatus? status,
    SearchResultEntity? result,
    String? errorMessage,
    String? query,
    List<String>? recentSearches,
    SearchSort? sort,
    SearchPriceRange? priceRange,
    SearchDietary? dietary,
    bool? under300,
    bool? rating4Plus,
    bool clearError = false,
    bool clearResult = false,
  }) {
    return SearchState(
      status: status ?? this.status,
      result: clearResult ? null : (result ?? this.result),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      query: query ?? this.query,
      recentSearches: recentSearches ?? this.recentSearches,
      sort: sort ?? this.sort,
      priceRange: priceRange ?? this.priceRange,
      dietary: dietary ?? this.dietary,
      under300: under300 ?? this.under300,
      rating4Plus: rating4Plus ?? this.rating4Plus,
    );
  }

  @override
  List<Object?> get props => [
    status,
    result,
    errorMessage,
    query,
    recentSearches,
    sort,
    priceRange,
    dietary,
    under300,
    rating4Plus,
  ];

  static int countVisible({
    required SearchResultEntity? result,
    required SearchFilterSelection selection,
    bool under300 = false,
    bool rating4Plus = false,
  }) {
    if (result == null) return 0;
    return result.categories.length +
        filterRestaurants(
          restaurants: result.restaurants,
          sort: selection.sort,
          rating4Plus: rating4Plus,
        ).length +
        filterItems(
          items: result.items,
          sort: selection.sort,
          priceRange: selection.priceRange,
          dietary: selection.dietary,
          under300: under300,
        ).length;
  }

  static List<RestaurantEntity> filterRestaurants({
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

  static List<MenuItemEntity> filterItems({
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
