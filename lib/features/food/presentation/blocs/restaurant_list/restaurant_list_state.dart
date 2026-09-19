import 'package:equatable/equatable.dart';
import '../../../../food/domain/entities/restaurant_entity.dart';

enum RestaurantListStatus { initial, loading, success, failure }

class RestaurantListState extends Equatable {
  final RestaurantListStatus status;
  final List<RestaurantEntity> restaurants;
  final String? errorMessage;

  const RestaurantListState({
    this.status = RestaurantListStatus.initial,
    this.restaurants = const [],
    this.errorMessage,
  });

  RestaurantListState copyWith({
    RestaurantListStatus? status,
    List<RestaurantEntity>? restaurants,
    String? errorMessage,
    bool clearError = false,
  }) {
    return RestaurantListState(
      status: status ?? this.status,
      restaurants: restaurants ?? this.restaurants,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, restaurants, errorMessage];
}
