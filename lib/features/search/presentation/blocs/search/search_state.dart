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
  final SearchFilterSelection filters;

  const SearchState({
    this.status = SearchStatus.initial,
    this.result,
    this.errorMessage,
    this.query = '',
    this.recentSearches = const [],
    this.filters = const SearchFilterSelection(),
  });

  bool get isIdle => query.trim().isEmpty;

  SearchState copyWith({
    SearchStatus? status,
    SearchResultEntity? result,
    String? errorMessage,
    String? query,
    List<String>? recentSearches,
    SearchFilterSelection? filters,
    bool clearError = false,
    bool clearResult = false,
  }) {
    return SearchState(
      status: status ?? this.status,
      result: clearResult ? null : (result ?? this.result),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      query: query ?? this.query,
      recentSearches: recentSearches ?? this.recentSearches,
      filters: filters ?? this.filters,
    );
  }

  @override
  List<Object?> get props => [
    status,
    result,
    errorMessage,
    query,
    recentSearches,
    filters,
  ];
}
