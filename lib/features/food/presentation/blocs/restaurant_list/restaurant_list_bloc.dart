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
    on<ApplyRestaurantFilter>(_onApplyFilter);
  }

  Future<void> _onLoadRestaurants(
    LoadRestaurants event,
    Emitter<RestaurantListState> emit,
  ) async {
    emit(
      state.copyWith(
        status: RestaurantListStatus.loading, 
        baseParams: event.params,
        currentParams: event.params,
        clearError: true,
      ),
    );

    try {
      await emit.forEach<List<RestaurantEntity>>(
        _getRestaurantsUseCase(event.params),
        onData: (restaurants) => state.copyWith(
          status: RestaurantListStatus.success,
          restaurants: restaurants,
          baseParams: event.params,
          currentParams: event.params,
        ),
        onError: (error, _) => state.copyWith(
          status: RestaurantListStatus.failure,
          restaurants: const [],
          errorMessage: error.toString(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RestaurantListStatus.failure,
          restaurants: const [],
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onRefreshRestaurants(
    RefreshRestaurants event,
    Emitter<RestaurantListState> emit,
  ) async {
    try {
      await emit.forEach<List<RestaurantEntity>>(
        _getRestaurantsUseCase(event.params),
        onData: (restaurants) => state.copyWith(
          status: RestaurantListStatus.success,
          restaurants: restaurants,
          currentParams: event.params,
        ),
        onError: (error, _) => state.copyWith(
          status: RestaurantListStatus.failure,
          restaurants: const [],
          errorMessage: error.toString(),
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        status: RestaurantListStatus.failure,
        restaurants: const [],
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onApplyFilter(
    ApplyRestaurantFilter event,
    Emitter<RestaurantListState> emit,
  ) async {
    final baseParams = state.baseParams;
    if (baseParams == null) return;

    if (event.index == null || event.filterParams == null) {
      // Clear filter
      emit(state.copyWith(clearFilter: true, currentParams: baseParams));
      add(RefreshRestaurants(params: baseParams));
    } else {
      // Apply filter
      final newParams = baseParams.copyWith(
        maxDeliveryFee: event.filterParams!.maxDeliveryFee,
        minRating: event.filterParams!.minRating,
        sort: event.filterParams!.sort ?? baseParams.sort,
      );
      emit(state.copyWith(selectedFilterIndex: event.index, currentParams: newParams));
      add(RefreshRestaurants(params: newParams));
    }
  }
}
