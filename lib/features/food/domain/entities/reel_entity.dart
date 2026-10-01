import 'package:equatable/equatable.dart';
import 'menu_entity.dart';
import 'restaurant_entity.dart';

class ReelsPaginationMetaEntity extends Equatable {
  final int total;
  final int limit;
  final int offset;
  final int page;
  final bool hasMore;

  const ReelsPaginationMetaEntity({
    required this.total,
    required this.limit,
    required this.offset,
    required this.page,
    required this.hasMore,
  });

  @override
  List<Object?> get props => [total, limit, offset, page, hasMore];
}

class ReelEntity extends Equatable {
  final String id;
  final String videoUrl;
  final String? thumbnailUrl;
  final String? caption;
  final int durationSeconds;
  final RestaurantEntity restaurant;
  final MenuItemEntity? menuItem;
  final DateTime createdAt;

  const ReelEntity({
    required this.id,
    required this.videoUrl,
    this.thumbnailUrl,
    this.caption,
    required this.durationSeconds,
    required this.restaurant,
    this.menuItem,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    videoUrl,
    thumbnailUrl,
    caption,
    durationSeconds,
    restaurant,
    menuItem,
    createdAt,
  ];
}

class ReelsResponseEntity extends Equatable {
  final List<ReelEntity> reels;
  final ReelsPaginationMetaEntity meta;

  const ReelsResponseEntity({
    required this.reels,
    required this.meta,
  });

  @override
  List<Object?> get props => [reels, meta];
}
