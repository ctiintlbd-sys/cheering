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
  final bool saveRecent;

  const LoadSearch({required this.query, this.saveRecent = true});

  @override
  List<Object?> get props => [query, saveRecent];
}

class ClearSearch extends SearchEvent {
  const ClearSearch();
}

class ApplySearchFilter extends SearchEvent {
  final SearchFilterSelection selection;

  const ApplySearchFilter({required this.selection});

  @override
  List<Object?> get props => [selection];
}
