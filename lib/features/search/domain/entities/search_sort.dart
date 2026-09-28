import 'package:equatable/equatable.dart';

enum SearchSort { relevance, priceLowToHigh, rating, deliveryTime }

enum SearchPriceRange { any, under200, under300, from200to500, over500 }

enum SearchDietary { any, healthy, vegetarian, spicy }

class SearchFilterSelection extends Equatable {
  const SearchFilterSelection({
    this.sort = SearchSort.relevance,
    this.priceRange = SearchPriceRange.any,
    this.dietary = SearchDietary.any,
    this.rating4Plus = false,
  });

  final SearchSort sort;
  final SearchPriceRange priceRange;
  final SearchDietary dietary;
  final bool rating4Plus;

  bool get hasPriceFilter => priceRange != SearchPriceRange.any;

  String get priceLabel => switch (priceRange) {
    SearchPriceRange.under200 => 'Under ৳200',
    SearchPriceRange.under300 => 'Under ৳300',
    SearchPriceRange.from200to500 => '৳200 - ৳500',
    SearchPriceRange.over500 => '৳500+',
    SearchPriceRange.any => 'Under ৳300',
  };

  SearchFilterSelection copyWith({
    SearchSort? sort,
    SearchPriceRange? priceRange,
    SearchDietary? dietary,
    bool? rating4Plus,
  }) {
    return SearchFilterSelection(
      sort: sort ?? this.sort,
      priceRange: priceRange ?? this.priceRange,
      dietary: dietary ?? this.dietary,
      rating4Plus: rating4Plus ?? this.rating4Plus,
    );
  }

  @override
  List<Object?> get props => [sort, priceRange, dietary, rating4Plus];
}
