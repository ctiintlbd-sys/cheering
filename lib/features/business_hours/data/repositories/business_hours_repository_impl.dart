import '../../domain/entities/business_hours_entity.dart';
import '../../domain/repositories/i_business_hours_repository.dart';
import '../datasources/business_hours_remote_source.dart';
import '../../../../core/network/api_result.dart';

class BusinessHoursRepositoryImpl implements IBusinessHoursRepository {
  final BusinessHoursRemoteSource _remoteSource;

  BusinessHoursRepositoryImpl(this._remoteSource);

  @override
  Future<BusinessHoursDataEntity> getBusinessHours() async {
    final result = await _remoteSource.getBusinessHours();
    return result.fold(
      onSuccess: (data) => data,
      onFailure: (error) => throw Exception(error.message),
    );
  }

  @override
  Future<void> updateBusinessHours(Map<String, DayHoursEntity> days) async {
    final result = await _remoteSource.updateBusinessHours(days);
    return result.fold(
      onSuccess: (_) => null,
      onFailure: (error) => throw Exception(error.message),
    );
  }
}
