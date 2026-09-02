import '../entities/business_hours_entity.dart';

abstract class IBusinessHoursRepository {
  Future<BusinessHoursDataEntity> getBusinessHours();
  Future<void> updateBusinessHours(Map<String, DayHoursEntity> days);
}
