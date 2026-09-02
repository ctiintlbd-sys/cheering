import 'package:cheering/core/config/chache_keys.dart';
import '../../../../core/cache/cache_service.dart';
import '../../domain/entities/overview_entity.dart';
import '../../domain/entities/performance_entity.dart';
import '../../domain/entities/report_entity.dart';
import '../../domain/repositories/i_overview_repository.dart';
import '../datasources/overview_remote_source.dart';
import '../models/overview_model.dart';
import '../models/performance_model.dart';
import '../models/report_model.dart';

class OverviewRepositoryImpl implements IOverviewRepository {
  final OverviewRemoteSource _source;
  final CacheService _cache;

  OverviewRepositoryImpl(this._source, this._cache);

  @override
  Stream<OverviewEntity> getDashboard() => _cache.getOrFetch(
        CacheKeys.dashboard,
        fromJson: (json) => OverviewDataModel.fromJson({'data': json}),
        toJson: (e) => (e as OverviewDataModel).toJson(),
        fetch: () => _source.getDashboard(),
        ttl: const Duration(minutes: 5),
      );

  @override
  Stream<PerformanceEntity> getPerformance({int windowDays = 30}) => _cache.getOrFetch(
        '${CacheKeys.performance}_$windowDays',
        fromJson: (json) => PerformanceModel.fromJson(json),
        toJson: (e) => (e as PerformanceModel).toJson(),
        fetch: () => _source.getPerformance(windowDays),
        ttl: const Duration(minutes: 30),
      );

  @override
  Stream<ReportEntity> getReport({String? dateFrom, String? dateTo}) {
    final keySuffix = '${dateFrom ?? 'default'}_${dateTo ?? 'default'}';
    return _cache.getOrFetch(
      '${CacheKeys.report}_$keySuffix',
      fromJson: (json) => ReportModel.fromJson(json),
      toJson: (e) => (e as ReportModel).toJson(),
      fetch: () => _source.getReport(dateFrom: dateFrom, dateTo: dateTo),
      ttl: const Duration(minutes: 30),
    );
  }
}
