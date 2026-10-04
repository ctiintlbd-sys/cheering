import 'package:equatable/equatable.dart';

class FavoriteToggleEntity extends Equatable {
  final String restaurantId;
  final bool isFavorite;

  const FavoriteToggleEntity({
    required this.restaurantId,
    required this.isFavorite,
  });

  @override
  List<Object?> get props => [restaurantId, isFavorite];
}
