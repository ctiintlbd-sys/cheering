import '../../domain/entities/performance_entity.dart';

class PerformanceModel extends PerformanceEntity {
  const PerformanceModel({
    required super.restaurantId,
    required super.windowDays,
    required super.acceptanceRate,
    required super.onTimeRate,
    required super.ratingAvg,
    required super.ratingCount,
    required super.rejectionsThisWeek,
  });

  factory PerformanceModel.fromJson(Map<String, dynamic> json) {
    return PerformanceModel(
      restaurantId: json['restaurant_id'] as String? ?? '',
      windowDays: (json['window_days'] as num?)?.toInt() ?? 30,
      acceptanceRate: (json['acceptance_rate'] as num?)?.toDouble() ?? 0.0,
      onTimeRate: (json['on_time_rate'] as num?)?.toDouble() ?? 0.0,
      ratingAvg: (json['rating_avg'] as num?)?.toDouble() ?? 0.0,
      ratingCount: (json['rating_count'] as num?)?.toInt() ?? 0,
      rejectionsThisWeek: (json['rejections_this_week'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'restaurant_id': restaurantId,
      'window_days': windowDays,
      'acceptance_rate': acceptanceRate,
      'on_time_rate': onTimeRate,
      'rating_avg': ratingAvg,
      'rating_count': ratingCount,
      'rejections_this_week': rejectionsThisWeek,
    };
  }
}
