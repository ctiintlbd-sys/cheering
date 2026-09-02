import 'package:equatable/equatable.dart';
import '../../domain/entities/overview_entity.dart';
import '../../domain/entities/performance_entity.dart';
import '../../domain/entities/report_entity.dart';

enum OverviewStatus {
  initial,
  loading,
  success,
  failure,
}

enum PerformanceStatus {
  initial,
  loading,
  success,
  failure,
}

enum ReportStatus {
  initial,
  loading,
  success,
  failure,
}

class OverviewState extends Equatable {
  final OverviewStatus status;
  final OverviewEntity? overview;
  final String? errorMessage;
  
  final PerformanceStatus performanceStatus;
  final PerformanceEntity? performance;
  final String? performanceErrorMessage;

  final ReportStatus reportStatus;
  final ReportEntity? report;
  final String? reportErrorMessage;
  final DateTime? reportFromDate;
  final DateTime? reportToDate;

  const OverviewState({
    this.status = OverviewStatus.initial,
    this.overview,
    this.errorMessage,
    this.performanceStatus = PerformanceStatus.initial,
    this.performance,
    this.performanceErrorMessage,
    this.reportStatus = ReportStatus.initial,
    this.report,
    this.reportErrorMessage,
    this.reportFromDate,
    this.reportToDate,
  });

  bool get isLoading => status == OverviewStatus.loading;
  bool get isPerformanceLoading => performanceStatus == PerformanceStatus.loading;
  bool get isReportLoading => reportStatus == ReportStatus.loading;

  OverviewState copyWith({
    OverviewStatus? status,
    OverviewEntity? overview,
    String? errorMessage,
    bool clearError = false,
    PerformanceStatus? performanceStatus,
    PerformanceEntity? performance,
    String? performanceErrorMessage,
    bool clearPerformanceError = false,
    ReportStatus? reportStatus,
    ReportEntity? report,
    String? reportErrorMessage,
    bool clearReportError = false,
    DateTime? reportFromDate,
    DateTime? reportToDate,
  }) {
    return OverviewState(
      status: status ?? this.status,
      overview: overview ?? this.overview,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      performanceStatus: performanceStatus ?? this.performanceStatus,
      performance: performance ?? this.performance,
      performanceErrorMessage: clearPerformanceError ? null : (performanceErrorMessage ?? this.performanceErrorMessage),
      reportStatus: reportStatus ?? this.reportStatus,
      report: report ?? this.report,
      reportErrorMessage: clearReportError ? null : (reportErrorMessage ?? this.reportErrorMessage),
      reportFromDate: reportFromDate ?? this.reportFromDate,
      reportToDate: reportToDate ?? this.reportToDate,
    );
  }

  @override
  List<Object?> get props => [
    status, 
    overview, 
    errorMessage,
    performanceStatus,
    performance,
    performanceErrorMessage,
    reportStatus,
    report,
    reportErrorMessage,
    reportFromDate,
    reportToDate,
  ];
}
