import 'package:equatable/equatable.dart';

import '../../../domain/entities/search_sort.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class LoadRecentSearches extends SearchEvent {
  const LoadRecentSearches();
}

class LoadSearch extends SearchEvent {
  final String query;

  const LoadSearch({required this.query});

  @override
  List<Object?> get props => [query];
}

class ClearSearch extends SearchEvent {
  const ClearSearch();
}

class ClearRecentSearches extends SearchEvent {
  const ClearRecentSearches();
}

class ApplySearchFilter extends SearchEvent {
  final SearchFilterSelection filters;

  const ApplySearchFilter({required this.filters});

  @override
  List<Object?> get props => [filters];
}
