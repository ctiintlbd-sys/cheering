import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../food/domain/entities/restaurant_entity.dart';
import '../../../../food/domain/usecases/get_restaurants_usecase.dart';
import 'restaurant_list_event.dart';
import 'restaurant_list_state.dart';

class RestaurantListBloc
    extends Bloc<RestaurantListEvent, RestaurantListState> {
  final GetRestaurantsUseCase _getRestaurantsUseCase;

  RestaurantListBloc(this._getRestaurantsUseCase)
    : super(const RestaurantListState()) {
    on<LoadRestaurants>(_onLoadRestaurants);
    on<RefreshRestaurants>(_onRefreshRestaurants);
  }

  Future<void> _onLoadRestaurants(
    LoadRestaurants event,
    Emitter<RestaurantListState> emit,
  ) async {
    emit(
      state.copyWith(status: RestaurantListStatus.loading, clearError: true),
    );

    try {
      await emit.forEach<List<RestaurantEntity>>(
        _getRestaurantsUseCase(event.params),
        onData: (restaurants) => RestaurantListState(
          status: RestaurantListStatus.success,
          restaurants: restaurants,
        ),
        onError: (error, _) => state.copyWith(
          status: RestaurantListStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RestaurantListStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onRefreshRestaurants(
    RefreshRestaurants event,
    Emitter<RestaurantListState> emit,
  ) async {
    // Intentionally omitting loading state to prevent UI flicker
    // Purono list UI te theke jabe, just background e data refresh hobe
    try {
      await emit.forEach<List<RestaurantEntity>>(
        _getRestaurantsUseCase(event.params),
        onData: (restaurants) => RestaurantListState(
          status: RestaurantListStatus.success,
          restaurants: restaurants,
        ),
        onError: (error, _) => state.copyWith(errorMessage: error.toString()),
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}
