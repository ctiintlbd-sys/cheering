import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';
import '../../../../food/domain/usecases/search_food_usecase.dart';
import 'search_food_event.dart';
import 'search_food_state.dart';

EventTransformer<E> debounceRestartable<E>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class SearchFoodBloc extends Bloc<SearchFoodEvent, SearchFoodState> {
  final SearchFoodUseCase _searchFoodUseCase;

  SearchFoodBloc(this._searchFoodUseCase) : super(const SearchFoodState()) {
    on<PerformSearch>(
      _onPerformSearch,
      transformer: debounceRestartable(const Duration(milliseconds: 400)),
    );
    on<ClearSearch>(_onClearSearch);
  }

  Future<void> _onPerformSearch(
    PerformSearch event,
    Emitter<SearchFoodState> emit,
  ) async {
    // Optional: If the query is empty but somehow bypasses the UI check
    if (event.params.q.isEmpty) {
      emit(const SearchFoodState());
      return;
    }

    // Google-style loading: keep old result on screen while loading new one
    emit(state.copyWith(status: SearchFoodStatus.loading, clearError: true));

    try {
      final result = await _searchFoodUseCase(event.params);

      emit(state.copyWith(status: SearchFoodStatus.success, result: result));
    } catch (e) {
      emit(
        state.copyWith(
          status: SearchFoodStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onClearSearch(ClearSearch event, Emitter<SearchFoodState> emit) {
    // Completely clear the state for an empty search text
    emit(const SearchFoodState());
  }
}
