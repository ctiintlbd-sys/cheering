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
    emit(state.copyWith(
      status: RestaurantDetailsStatus.loading, 
      restaurant: event.restaurant,
      clearError: true
    ));

    try {
      final (updatedRestaurant, menuCategories) = await (
        _getRestaurantDetailsUseCase(
          event.restaurant.id,
        ),
        _getRestaurantMenuUseCase(event.restaurant.id),
      ).wait;

      emit(
        state.copyWith(
          status: RestaurantDetailsStatus.success,
          restaurant: updatedRestaurant,
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
