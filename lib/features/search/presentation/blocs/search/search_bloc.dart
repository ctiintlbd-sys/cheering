import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/storage/recent_search_storage.dart';
import '../../../domain/entities/search_params.dart';
import '../../../domain/entities/search_sort.dart';
import '../../../domain/usecases/get_search_results_usecase.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(this._getSearchResults) : super(const SearchState()) {
    on<LoadRecentSearches>(_onLoadRecentSearches);
    on<QueryChanged>(_onQueryChanged);
    on<ClearSearch>(_onClearSearch);
    on<ToggleUnder300>(_onToggleUnder300);
    on<ToggleRating4Plus>(_onToggleRating4Plus);
    on<ToggleFastest>(_onToggleFastest);
    on<ApplyFilters>(_onApplyFilters);
  }

  final GetSearchResultsUseCase _getSearchResults;

  void _onLoadRecentSearches(
    LoadRecentSearches event,
    Emitter<SearchState> emit,
  ) {
    emit(state.copyWith(recentSearches: RecentSearchStorage.getRecent()));
  }

  Future<void> _onQueryChanged(
    QueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    await _search(event.query, emit);
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

  void _onToggleUnder300(ToggleUnder300 event, Emitter<SearchState> emit) {
    emit(
      state.copyWith(
        under300: !state.under300,
        priceRange: SearchPriceRange.any,
      ),
    );
  }

  void _onToggleRating4Plus(
    ToggleRating4Plus event,
    Emitter<SearchState> emit,
  ) {
    emit(state.copyWith(rating4Plus: !state.rating4Plus));
  }

  Future<void> _onToggleFastest(
    ToggleFastest event,
    Emitter<SearchState> emit,
  ) async {
    final next = state.sort == SearchSort.deliveryTime
        ? SearchSort.relevance
        : SearchSort.deliveryTime;
    emit(state.copyWith(sort: next));
    if (state.query.trim().isNotEmpty) {
      await _search(state.query, emit);
    }
  }

  Future<void> _onApplyFilters(
    ApplyFilters event,
    Emitter<SearchState> emit,
  ) async {
    final sortChanged = event.selection.sort != state.sort;
    emit(
      state.copyWith(
        sort: event.selection.sort,
        priceRange: event.selection.priceRange,
        dietary: event.selection.dietary,
        under300: false,
      ),
    );
    if (sortChanged && state.query.trim().isNotEmpty) {
      await _search(state.query, emit);
    }
  }

  Future<void> _search(String rawQuery, Emitter<SearchState> emit) async {
    final query = rawQuery.trim();
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
      final result = await _getSearchResults(_params(query));
      await RecentSearchStorage.save(query);
      emit(
        state.copyWith(
          status: SearchStatus.success,
          result: result,
          recentSearches: RecentSearchStorage.getRecent(),
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: SearchStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  SearchParams _params(String query) {
    return SearchParams(
      q: query,
      sort: switch (state.sort) {
        SearchSort.rating => '-rating_avg',
        SearchSort.deliveryTime => 'prep_time',
        SearchSort.relevance || SearchSort.priceLowToHigh => null,
      },
    );
  }
}
