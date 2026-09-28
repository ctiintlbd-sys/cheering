import 'package:equatable/equatable.dart';

enum SearchSort { relevance, priceLowToHigh, rating, deliveryTime }

enum SearchPriceRange { any, under200, from200to500, over500 }

enum SearchDietary { any, healthy, vegetarian, spicy }

class SearchFilterSelection extends Equatable {
  const SearchFilterSelection({
    this.sort = SearchSort.relevance,
    this.priceRange = SearchPriceRange.any,
    this.dietary = SearchDietary.any,
    this.under300 = false,
    this.rating4Plus = false,
  });

  final SearchSort sort;
  final SearchPriceRange priceRange;
  final SearchDietary dietary;
  final bool under300;
  final bool rating4Plus;

  SearchFilterSelection copyWith({
    SearchSort? sort,
    SearchPriceRange? priceRange,
    SearchDietary? dietary,
    bool? under300,
    bool? rating4Plus,
  }) {
    return SearchFilterSelection(
      sort: sort ?? this.sort,
      priceRange: priceRange ?? this.priceRange,
      dietary: dietary ?? this.dietary,
      under300: under300 ?? this.under300,
      rating4Plus: rating4Plus ?? this.rating4Plus,
    );
  }

  @override
  List<Object?> get props => [sort, priceRange, dietary, under300, rating4Plus];
}
