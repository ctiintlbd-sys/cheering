import '../entities/business_hours_entity.dart';
import '../repositories/i_business_hours_repository.dart';

class GetBusinessHoursUseCase {
  final IBusinessHoursRepository _repository;

  GetBusinessHoursUseCase(this._repository);

  Future<BusinessHoursDataEntity> call() {
    return _repository.getBusinessHours();
  }
}

class UpdateBusinessHoursUseCase {
  final IBusinessHoursRepository _repository;

  UpdateBusinessHoursUseCase(this._repository);

  Future<void> call(Map<String, DayHoursEntity> days) {
    return _repository.updateBusinessHours(days);
  }
}
