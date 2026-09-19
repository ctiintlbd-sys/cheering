import 'package:equatable/equatable.dart';
import '../../../../food/domain/entities/restaurant_entity.dart';
import '../../../../food/domain/entities/menu_entity.dart';

enum RestaurantDetailsStatus { initial, loading, success, failure }

class RestaurantDetailsState extends Equatable {
  final RestaurantDetailsStatus status;
  final RestaurantEntity? restaurant;
  final List<MenuCategoryEntity> menuCategories;
  final String? errorMessage;

  const RestaurantDetailsState({
    this.status = RestaurantDetailsStatus.initial,
    this.restaurant,
    this.menuCategories = const [],
    this.errorMessage,
  });

  RestaurantDetailsState copyWith({
    RestaurantDetailsStatus? status,
    RestaurantEntity? restaurant,
    List<MenuCategoryEntity>? menuCategories,
    String? errorMessage,
    bool clearError = false,
  }) {
    return RestaurantDetailsState(
      status: status ?? this.status,
      restaurant: restaurant ?? this.restaurant,
      menuCategories: menuCategories ?? this.menuCategories,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, restaurant, menuCategories, errorMessage];
}
