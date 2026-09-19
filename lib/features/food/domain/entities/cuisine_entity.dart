import 'package:equatable/equatable.dart';

class CuisineEntity extends Equatable {
  final String name;
  final int restaurantCount;
  final String? imageUrl;

  const CuisineEntity({
    required this.name,
    required this.restaurantCount,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [name, restaurantCount, imageUrl];
}
