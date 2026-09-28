import 'package:equatable/equatable.dart';

import '../../../domain/entities/search_result_entity.dart';
import '../../../domain/entities/search_sort.dart';

enum SearchStatus { initial, loading, success, failure }

class SearchState extends Equatable {
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

  bool get isIdle => query.trim().isEmpty;

  SearchFilterSelection get filterSelection => SearchFilterSelection(
    sort: sort,
    priceRange: priceRange,
    dietary: dietary,
    under300: under300,
    rating4Plus: rating4Plus,
  );

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
}
