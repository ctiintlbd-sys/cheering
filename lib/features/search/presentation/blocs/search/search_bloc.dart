import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/storage/recent_search_storage.dart';
import '../../../domain/entities/search_params.dart';
import '../../../domain/entities/search_sort.dart';
import '../../../domain/usecases/get_search_results_usecase.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final GetSearchResultsUseCase _getSearchResultsUseCase;

  SearchBloc(this._getSearchResultsUseCase) : super(const SearchState()) {
    on<LoadRecentSearches>(_onLoadRecentSearches);
    on<LoadSearch>(_onLoadSearch);
    on<ClearSearch>(_onClearSearch);
    on<ClearRecentSearches>(_onClearRecentSearches);
    on<ApplySearchFilter>(_onApplySearchFilter);
  }

  void _onLoadRecentSearches(
    LoadRecentSearches event,
    Emitter<SearchState> emit,
  ) {
    emit(state.copyWith(recentSearches: RecentSearchStorage.getRecent()));
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
          sort: switch (state.filters.sort) {
            SearchSort.rating => '-rating_avg',
            SearchSort.deliveryTime => 'prep_time',
            SearchSort.priceLowToHigh => 'price',
            SearchSort.relevance => null,
          },
        ),
      );
      await RecentSearchStorage.save(query);
      emit(
        state.copyWith(
          status: SearchStatus.success,
          result: result,
          recentSearches: RecentSearchStorage.getRecent(),
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

  Future<void> _onClearRecentSearches(
    ClearRecentSearches event,
    Emitter<SearchState> emit,
  ) async {
    await RecentSearchStorage.clear();
    emit(state.copyWith(recentSearches: const []));
  }

  void _onApplySearchFilter(
    ApplySearchFilter event,
    Emitter<SearchState> emit,
  ) {
    emit(state.copyWith(filters: event.filters));
    if (state.query.trim().isNotEmpty) {
      add(LoadSearch(query: state.query));
    }
  }
}
