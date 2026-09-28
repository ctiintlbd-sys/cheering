import 'package:equatable/equatable.dart';

enum SearchSort { relevance, priceLowToHigh, rating, deliveryTime }

enum SearchPriceRange { any, under200, from200to500, over500 }

enum SearchDietary { any, healthy, vegetarian, spicy }

class SearchFilterSelection extends Equatable {
  const SearchFilterSelection({
    this.sort = SearchSort.relevance,
    this.priceRange = SearchPriceRange.any,
    this.dietary = SearchDietary.any,
  });

  final SearchSort sort;
  final SearchPriceRange priceRange;
  final SearchDietary dietary;

  @override
  List<Object?> get props => [sort, priceRange, dietary];
}
