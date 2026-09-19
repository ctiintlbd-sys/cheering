import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../food/domain/usecases/get_restaurant_details_usecase.dart';
import '../../../../food/domain/usecases/get_restaurant_menu_usecase.dart';
import 'restaurant_details_event.dart';
import 'restaurant_details_state.dart';

class RestaurantDetailsBloc
    extends Bloc<RestaurantDetailsEvent, RestaurantDetailsState> {
  final GetRestaurantDetailsUseCase _getRestaurantDetailsUseCase;
  final GetRestaurantMenuUseCase _getRestaurantMenuUseCase;

  RestaurantDetailsBloc(
    this._getRestaurantDetailsUseCase,
    this._getRestaurantMenuUseCase,
  ) : super(const RestaurantDetailsState()) {
    on<LoadRestaurantDetails>(_onLoadRestaurantDetails);
  }

  Future<void> _onLoadRestaurantDetails(
    LoadRestaurantDetails event,
    Emitter<RestaurantDetailsState> emit,
  ) async {
    emit(
      state.copyWith(status: RestaurantDetailsStatus.loading, clearError: true),
    );

    try {
      // Parallel fetch — type safe with Dart 3 records
      final (restaurant, menuCategories) = await (
        _getRestaurantDetailsUseCase(
          event.restaurantId,
          lat: event.lat,
          lng: event.lng,
        ),
        _getRestaurantMenuUseCase(event.restaurantId),
      ).wait;

      emit(
        state.copyWith(
          status: RestaurantDetailsStatus.success,
          restaurant: restaurant,
          menuCategories: menuCategories,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RestaurantDetailsStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
