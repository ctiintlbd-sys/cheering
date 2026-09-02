import '../../../../core/config/api_endpoints.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/i_api_client.dart';
import '../models/business_hours_model.dart';
import '../../domain/entities/business_hours_entity.dart';

class BusinessHoursRemoteSource {
  final IApiClient _client;

  BusinessHoursRemoteSource(this._client);

  Future<ApiResult<BusinessHoursDataModel>> getBusinessHours() {
    return _client.get(
      ApiEndpoints.vendorHours,
      fromJson: (json) => BusinessHoursDataModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Future<ApiResult<void>> updateBusinessHours(Map<String, DayHoursEntity> days) {
    final Map<String, dynamic> body = {};
    days.forEach((key, value) {
      body[key] = {
        'is_open': value.isOpen,
        if (value.opensAt.isNotEmpty) 'opens_at': value.opensAt,
        if (value.closesAt.isNotEmpty) 'closes_at': value.closesAt,
      };
    });
    return _client.put<void>(
      ApiEndpoints.vendorHours,
      body: body,
      fromJson: (_) {},
    );
  }
}
