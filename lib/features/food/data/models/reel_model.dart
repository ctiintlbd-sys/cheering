import '../../domain/entities/reel_entity.dart';
import 'menu_model.dart';
import 'restaurant_model.dart';

class ReelsPaginationMetaModel extends ReelsPaginationMetaEntity {
  const ReelsPaginationMetaModel({
    required super.total,
    required super.limit,
    required super.offset,
    required super.page,
    required super.hasMore,
  });

  factory ReelsPaginationMetaModel.fromJson(Map<String, dynamic> json) {
    return ReelsPaginationMetaModel(
      total: json['total'] as int? ?? 0,
      limit: json['limit'] as int? ?? 20,
      offset: json['offset'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      hasMore: json['has_more'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'limit': limit,
      'offset': offset,
      'page': page,
      'has_more': hasMore,
    };
  }
}

class ReelModel extends ReelEntity {
  const ReelModel({
    required super.id,
    required super.videoUrl,
    super.thumbnailUrl,
    super.caption,
    required super.durationSeconds,
    required super.restaurant,
    super.menuItem,
    required super.createdAt,
  });

  factory ReelModel.fromJson(Map<String, dynamic> json) {
    return ReelModel(
      id: json['id'] as String? ?? '',
      videoUrl: json['video_url'] as String? ?? '',
      thumbnailUrl: json['thumbnail_url'] as String?,
      caption: json['caption'] as String?,
      durationSeconds: (json['duration_seconds'] as num?)?.toInt() ?? 0,
      restaurant: RestaurantModel.fromJson(
        json['restaurant'] as Map<String, dynamic>? ?? {},
      ),
      menuItem: json['menu_item'] != null
          ? MenuItemModel.fromJson(json['menu_item'] as Map<String, dynamic>)
          : null,
      createdAt: json['created_at'] != null
          ? (DateTime.tryParse(json['created_at'] as String) ?? DateTime.now())
          : DateTime.now(),
    );
  }

  factory ReelModel.fromEntity(ReelEntity entity) {
    if (entity is ReelModel) return entity;
    return ReelModel(
      id: entity.id,
      videoUrl: entity.videoUrl,
      thumbnailUrl: entity.thumbnailUrl,
      caption: entity.caption,
      durationSeconds: entity.durationSeconds,
      restaurant: entity.restaurant,
      menuItem: entity.menuItem,
      createdAt: entity.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'video_url': videoUrl,
      'thumbnail_url': thumbnailUrl,
      'caption': caption,
      'duration_seconds': durationSeconds,
      'restaurant': restaurant is RestaurantModel
          ? (restaurant as RestaurantModel).toJson()
          : {
              'id': restaurant.id,
              'name': restaurant.name,
              'slug': restaurant.slug,
              'cuisine_types': restaurant.cuisineTypes,
              'logo_url': restaurant.logoUrl,
              'cover_image_url': restaurant.coverImageUrl,
              'rating_avg': restaurant.ratingAvg,
              'rating_count': restaurant.ratingCount,
              'avg_prep_time_mins': restaurant.avgPrepTimeMins,
              'delivery_fee': restaurant.deliveryFee,
              'min_order_amount': restaurant.minOrderAmount,
              'is_open': restaurant.isOpen,
              'distance_km': restaurant.distanceKm,
              'is_favorite': restaurant.isFavorite,
            },
      'menu_item': menuItem != null
          ? {
              'id': menuItem!.id,
              'name': menuItem!.name,
              'base_price': menuItem!.basePrice,
              'image_url': menuItem!.imageUrl,
            }
          : null,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class ReelsResponseModel extends ReelsResponseEntity {
  const ReelsResponseModel({
    required super.reels,
    required super.meta,
  });

  factory ReelsResponseModel.fromJson(Map<String, dynamic> json) {
    final list = json['data'] as List<dynamic>? ?? [];
    final reels = list
        .map((e) => ReelModel.fromJson(e as Map<String, dynamic>))
        .toList();
    final meta = ReelsPaginationMetaModel.fromJson(
      json['meta'] as Map<String, dynamic>? ?? {},
    );

    return ReelsResponseModel(
      reels: reels,
      meta: meta,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': reels
          .map((e) => e is ReelModel ? e.toJson() : ReelModel.fromEntity(e).toJson())
          .toList(),
      'meta': meta is ReelsPaginationMetaModel
          ? (meta as ReelsPaginationMetaModel).toJson()
          : {
              'total': meta.total,
              'limit': meta.limit,
              'offset': meta.offset,
              'page': meta.page,
              'has_more': meta.hasMore,
            },
    };
  }
}
