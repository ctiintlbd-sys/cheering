import 'package:equatable/equatable.dart';
import '../../../../food/domain/entities/restaurant_entity.dart';
import '../../../../food/domain/entities/restaurant_query_params.dart';

enum RestaurantListStatus { initial, loading, success, failure }

class RestaurantListState extends Equatable {
  final RestaurantListStatus status;
  final List<RestaurantEntity> restaurants;
  final String? errorMessage;
  final int? selectedFilterIndex;
  final RestaurantQueryParams? baseParams;
  final RestaurantQueryParams? currentParams;

  const RestaurantListState({
    this.status = RestaurantListStatus.initial,
    this.restaurants = const [],
    this.errorMessage,
    this.selectedFilterIndex,
    this.baseParams,
    this.currentParams,
  });

  RestaurantListState copyWith({
    RestaurantListStatus? status,
    List<RestaurantEntity>? restaurants,
    String? errorMessage,
    int? selectedFilterIndex,
    RestaurantQueryParams? baseParams,
    RestaurantQueryParams? currentParams,
    bool clearError = false,
    bool clearFilter = false,
  }) {
    return RestaurantListState(
      status: status ?? this.status,
      restaurants: restaurants ?? this.restaurants,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      selectedFilterIndex: clearFilter ? null : (selectedFilterIndex ?? this.selectedFilterIndex),
      baseParams: baseParams ?? this.baseParams,
      currentParams: currentParams ?? this.currentParams,
    );
  }

  @override
  List<Object?> get props => [status, restaurants, errorMessage, selectedFilterIndex, baseParams, currentParams];
}
