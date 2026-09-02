import '../../../../core/config/api_endpoints.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/i_api_client.dart';
import '../models/overview_model.dart';
import '../models/performance_model.dart';
import '../models/report_model.dart';

class OverviewRemoteSource {
  final IApiClient _client;

  OverviewRemoteSource(this._client);

  Future<ApiResult<OverviewDataModel>> getDashboard() {
    return _client.get(
      ApiEndpoints.dashboard,
      fromJson: (json) => OverviewDataModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResult<PerformanceModel>> getPerformance(int windowDays) {
    return _client.get(
      ApiEndpoints.performance,
      queryParameters: {'window_days': windowDays},
      fromJson: (json) => PerformanceModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResult<ReportModel>> getReport({String? dateFrom, String? dateTo}) {
    final Map<String, dynamic> query = {};
    if (dateFrom != null) query['date_from'] = dateFrom;
    if (dateTo != null) query['date_to'] = dateTo;
    
    return _client.get(
      ApiEndpoints.analytics,
      queryParameters: query.isEmpty ? null : query,
      fromJson: (json) => ReportModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
