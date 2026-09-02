import '../entities/overview_entity.dart';
import '../entities/performance_entity.dart';
import '../entities/report_entity.dart';

abstract class IOverviewRepository {
  Stream<OverviewEntity> getDashboard();
  Stream<PerformanceEntity> getPerformance({int windowDays = 30});
  Stream<ReportEntity> getReport({String? dateFrom, String? dateTo});
}
