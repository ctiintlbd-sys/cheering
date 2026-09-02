class DayHoursEntity {
  final bool isOpen;
  final String opensAt;
  final String closesAt;

  const DayHoursEntity({
    required this.isOpen,
    required this.opensAt,
    required this.closesAt,
  });

  DayHoursEntity copyWith({
    bool? isOpen,
    String? opensAt,
    String? closesAt,
  }) {
    return DayHoursEntity(
      isOpen: isOpen ?? this.isOpen,
      opensAt: opensAt ?? this.opensAt,
      closesAt: closesAt ?? this.closesAt,
    );
  }
}

class BusinessHoursDataEntity {
  final String restaurantId;
  final bool isConfigured;
  final Map<String, DayHoursEntity> days;
  final String storeStatus;

  const BusinessHoursDataEntity({
    required this.restaurantId,
    required this.isConfigured,
    required this.days,
    required this.storeStatus,
  });

  BusinessHoursDataEntity copyWith({
    String? restaurantId,
    bool? isConfigured,
    Map<String, DayHoursEntity>? days,
    String? storeStatus,
  }) {
    return BusinessHoursDataEntity(
      restaurantId: restaurantId ?? this.restaurantId,
      isConfigured: isConfigured ?? this.isConfigured,
      days: days ?? this.days,
      storeStatus: storeStatus ?? this.storeStatus,
    );
  }
}
