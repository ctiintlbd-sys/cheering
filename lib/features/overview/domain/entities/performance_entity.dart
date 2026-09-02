import 'package:equatable/equatable.dart';

class PerformanceEntity extends Equatable {
  final String restaurantId;
  final int windowDays;
  final double acceptanceRate;
  final double onTimeRate;
  final double ratingAvg;
  final int ratingCount;
  final int rejectionsThisWeek;

  const PerformanceEntity({
    required this.restaurantId,
    required this.windowDays,
    required this.acceptanceRate,
    required this.onTimeRate,
    required this.ratingAvg,
    required this.ratingCount,
    required this.rejectionsThisWeek,
  });

  @override
  List<Object?> get props => [
        restaurantId,
        windowDays,
        acceptanceRate,
        onTimeRate,
        ratingAvg,
        ratingCount,
        rejectionsThisWeek,
      ];
}
