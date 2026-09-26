import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
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
  }

  Future<void> _onLoadHomeFeed(
    LoadHomeFeed event,
    Emitter<HomeFeedState> emit,
  ) async {
    emit(state.copyWith(status: HomeFeedStatus.loading, clearError: true));

    try {
      // Merge both streams to fetch home feed and all categories simultaneously
      final combinedStream = Rx.combineLatest2(
        _getHomeFeedUseCase(lat: event.lat, lng: event.lng),
        _getCategoriesUseCase(),
        (HomeFeedEntity feed, List<CategoryEntity> categories) =>
            (feed, categories),
      );

      await emit.forEach<(HomeFeedEntity, List<CategoryEntity>)>(
        combinedStream,
        onData: (data) => HomeFeedState(
          status: HomeFeedStatus.success,
          feed: data.$1,
          allCategories: data.$2,
          errorMessage: state.errorMessage,
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
}
