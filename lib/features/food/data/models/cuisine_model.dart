import '../../domain/entities/cuisine_entity.dart';

class CuisineModel extends CuisineEntity {
  const CuisineModel({
    required super.name,
    required super.restaurantCount,
    super.imageUrl,
  });

  factory CuisineModel.fromJson(Map<String, dynamic> json) {
    return CuisineModel(
      name: json['name'] as String? ?? '',
      restaurantCount: json['restaurant_count'] as int? ?? 0,
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'restaurant_count': restaurantCount,
      'image_url': imageUrl,
    };
  }
}
