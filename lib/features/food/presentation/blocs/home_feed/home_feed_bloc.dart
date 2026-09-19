import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../food/domain/entities/home_feed_entity.dart';
import '../../../../food/domain/entities/category_entity.dart';
import '../../../../food/domain/usecases/get_home_feed_usecase.dart';
import '../../../../food/domain/usecases/get_categories_usecase.dart';
import 'home_feed_event.dart';
import 'home_feed_state.dart';

class HomeFeedBloc extends Bloc<HomeFeedEvent, HomeFeedState> {
  final GetHomeFeedUseCase _getHomeFeedUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;

  HomeFeedBloc(this._getHomeFeedUseCase, this._getCategoriesUseCase)
    : super(const HomeFeedState()) {
    on<LoadHomeFeed>(_onLoadHomeFeed);
    on<LoadAllCategories>(_onLoadAllCategories);
  }

  Future<void> _onLoadHomeFeed(
    LoadHomeFeed event,
    Emitter<HomeFeedState> emit,
  ) async {
    emit(state.copyWith(status: HomeFeedStatus.loading, clearError: true));

    try {
      await emit.forEach<HomeFeedEntity>(
        _getHomeFeedUseCase(lat: event.lat, lng: event.lng),
        onData: (feed) => HomeFeedState(
          status: HomeFeedStatus.success,
          feed: feed,
          allCategories: state.allCategories,
        ),
        onError: (error, _) => HomeFeedState(
          status: HomeFeedStatus.failure,
          feed: state.feed,
          allCategories: state.allCategories,
          errorMessage: error.toString(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeFeedStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadAllCategories(
    LoadAllCategories event,
    Emitter<HomeFeedState> emit,
  ) async {
    if (state.allCategories != null && state.allCategories!.isNotEmpty) return;

    emit(state.copyWith(isLoadingAllCategories: true));

    try {
      await emit.forEach<List<CategoryEntity>>(
        _getCategoriesUseCase(),
        onData: (categories) => HomeFeedState(
          status: state.status,
          feed: state.feed,
          allCategories: categories,
          isLoadingAllCategories: false,
          errorMessage: state.errorMessage,
        ),
        onError: (error, _) => HomeFeedState(
          status: state.status,
          feed: state.feed,
          allCategories: state.allCategories,
          isLoadingAllCategories: false,
          categoriesErrorMessage: error.toString(),
          errorMessage: state.errorMessage,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingAllCategories: false,
          categoriesErrorMessage: e.toString(),
        ),
      );
    }
  }
}
