import '../../domain/entities/favorite_toggle_entity.dart';

class FavoriteToggleModel extends FavoriteToggleEntity {
  const FavoriteToggleModel({
    required super.restaurantId,
    required super.isFavorite,
  });

  factory FavoriteToggleModel.fromJson(Map<String, dynamic> json) {
    return FavoriteToggleModel(
      restaurantId: json['restaurant_id'] as String? ?? '',
      isFavorite: json['is_favorite'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'restaurant_id': restaurantId,
      'is_favorite': isFavorite,
    };
  }
}
