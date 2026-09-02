import '../../domain/entities/business_hours_entity.dart';

class DayHoursModel extends DayHoursEntity {
  const DayHoursModel({
    required super.isOpen,
    required super.opensAt,
    required super.closesAt,
  });

  factory DayHoursModel.fromJson(Map<String, dynamic> json) {
    return DayHoursModel(
      isOpen: json['is_open'] as bool? ?? false,
      opensAt: json['opens_at']?.toString() ?? '',
      closesAt: json['closes_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_open': isOpen,
      'opens_at': opensAt,
      'closes_at': closesAt,
    };
  }
}

class BusinessHoursDataModel extends BusinessHoursDataEntity {
  const BusinessHoursDataModel({
    required super.restaurantId,
    required super.isConfigured,
    required super.days,
    required super.storeStatus,
  });

  factory BusinessHoursDataModel.fromJson(Map<String, dynamic> json) {
    final daysJson = json['days'] as Map<String, dynamic>? ?? {};
    final parsedDays = <String, DayHoursEntity>{};

    daysJson.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        parsedDays[key] = DayHoursModel.fromJson(value);
      }
    });

    return BusinessHoursDataModel(
      restaurantId: json['restaurant_id']?.toString() ?? '',
      isConfigured: json['is_configured'] as bool? ?? false,
      days: parsedDays,
      storeStatus: json['store_status']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final daysMap = <String, dynamic>{};
    days.forEach((key, value) {
      if (value is DayHoursModel) {
        daysMap[key] = value.toJson();
      } else {
        daysMap[key] = DayHoursModel(
          isOpen: value.isOpen,
          opensAt: value.opensAt,
          closesAt: value.closesAt,
        ).toJson();
      }
    });

    return {
      'restaurant_id': restaurantId,
      'is_configured': isConfigured,
      'days': daysMap,
      'store_status': storeStatus,
    };
  }
}
