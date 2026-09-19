import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String id;
  final String name;
  final String slug;
  final String? imageUrl;
  final int restaurantCount;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.slug,
    this.imageUrl,
    required this.restaurantCount,
  });

  @override
  List<Object?> get props => [id, name, slug, imageUrl, restaurantCount];
}
