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

class QueryChanged extends SearchEvent {
  const QueryChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

class ClearSearch extends SearchEvent {
  const ClearSearch();
}

class ToggleUnder300 extends SearchEvent {
  const ToggleUnder300();
}

class ToggleRating4Plus extends SearchEvent {
  const ToggleRating4Plus();
}

class ToggleFastest extends SearchEvent {
  const ToggleFastest();
}

class ApplyFilters extends SearchEvent {
  const ApplyFilters(this.selection);

  final SearchFilterSelection selection;

  @override
  List<Object?> get props => [selection];
}
