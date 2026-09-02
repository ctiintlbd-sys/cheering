import '../entities/overview_entity.dart';
import '../entities/performance_entity.dart';
import '../entities/report_entity.dart';
import '../repositories/i_overview_repository.dart';

class GetOverviewUseCase {
  final IOverviewRepository _repository;

  GetOverviewUseCase(this._repository);

  Stream<OverviewEntity> call() {
    return _repository.getDashboard();
  }
}

class GetPerformanceUseCase {
  final IOverviewRepository _repository;

  GetPerformanceUseCase(this._repository);

  Stream<PerformanceEntity> call({int windowDays = 30}) {
    return _repository.getPerformance(windowDays: windowDays);
  }
}

class GetReportUseCase {
  final IOverviewRepository _repository;

  GetReportUseCase(this._repository);

  Stream<ReportEntity> call({String? dateFrom, String? dateTo}) {
    return _repository.getReport(dateFrom: dateFrom, dateTo: dateTo);
  }
}
