import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/search_params.dart';
import '../../../domain/entities/search_sort.dart';
import '../../../domain/usecases/get_recent_searches_usecase.dart';
import '../../../domain/usecases/get_search_results_usecase.dart';
import '../../../domain/usecases/save_recent_search_usecase.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final GetSearchResultsUseCase _getSearchResultsUseCase;
  final GetRecentSearchesUseCase _getRecentSearchesUseCase;
  final SaveRecentSearchUseCase _saveRecentSearchUseCase;

  SearchBloc(
    this._getSearchResultsUseCase,
    this._getRecentSearchesUseCase,
    this._saveRecentSearchUseCase,
  ) : super(const SearchState()) {
    on<LoadRecentSearches>(_onLoadRecentSearches);
    on<LoadSearch>(_onLoadSearch);
    on<ClearSearch>(_onClearSearch);
    on<ApplySearchFilter>(_onApplySearchFilter);
  }

  void _onLoadRecentSearches(
    LoadRecentSearches event,
    Emitter<SearchState> emit,
  ) {
    emit(state.copyWith(recentSearches: _getRecentSearchesUseCase()));
  }

  Future<void> _onLoadSearch(
    LoadSearch event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();
    if (query.isEmpty) {
      emit(
        state.copyWith(
          query: '',
          status: SearchStatus.initial,
          clearResult: true,
          clearError: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        query: query,
        status: SearchStatus.loading,
        clearError: true,
      ),
    );

    try {
      final result = await _getSearchResultsUseCase(
        SearchParams(
          q: query,
          sort: switch (state.sort) {
            SearchSort.rating => '-rating_avg',
            SearchSort.deliveryTime => 'prep_time',
            SearchSort.relevance || SearchSort.priceLowToHigh => null,
          },
        ),
      );
      await _saveRecentSearchUseCase(query);
      emit(
        state.copyWith(
          status: SearchStatus.success,
          result: result,
          recentSearches: _getRecentSearchesUseCase(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SearchStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onClearSearch(ClearSearch event, Emitter<SearchState> emit) {
    emit(
      state.copyWith(
        query: '',
        status: SearchStatus.initial,
        clearResult: true,
        clearError: true,
      ),
    );
  }

  void _onApplySearchFilter(
    ApplySearchFilter event,
    Emitter<SearchState> emit,
  ) {
    final sortChanged = event.selection.sort != state.sort;
    emit(
      state.copyWith(
        sort: event.selection.sort,
        priceRange: event.selection.priceRange,
        dietary: event.selection.dietary,
        under300: event.selection.under300,
        rating4Plus: event.selection.rating4Plus,
      ),
    );
    if (sortChanged && state.query.trim().isNotEmpty) {
      add(LoadSearch(query: state.query));
    }
  }
}
