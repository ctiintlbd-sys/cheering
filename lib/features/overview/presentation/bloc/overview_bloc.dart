import 'dart:async';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/overview_entity.dart';
import '../../domain/entities/performance_entity.dart';
import '../../domain/entities/report_entity.dart';
import '../../domain/usecases/overview_usecases.dart';
import 'overview_event.dart';
import 'overview_state.dart';

import '../../../../core/utils/app_date_formatter.dart';

class OverviewBloc extends Bloc<OverviewEvent, OverviewState> {
  final GetOverviewUseCase getOverview;
  final GetPerformanceUseCase getPerformance;
  final GetReportUseCase getReport;

  OverviewBloc({
    required this.getOverview,
    required this.getPerformance,
    required this.getReport,
  }) : super(const OverviewState()) {
    on<LoadOverview>(_onLoadOverview, transformer: restartable());
    on<LoadPerformance>(_onLoadPerformance, transformer: restartable());
    on<LoadReport>(_onLoadReport, transformer: restartable());
    on<UpdateReportDateRange>(_onUpdateReportDateRange);
  }

  Future<void> _onLoadOverview(
    LoadOverview event,
    Emitter<OverviewState> emit,
  ) async {
    if (state.status != OverviewStatus.success) {
      emit(state.copyWith(status: OverviewStatus.loading));
    }

    try {
      await emit.forEach<OverviewEntity>(
        getOverview(),
        onData: (overview) {
          return state.copyWith(
            status: OverviewStatus.success,
            overview: overview,
            clearError: true,
          );
        },
        onError: (error, stackTrace) {
          if (state.status == OverviewStatus.success) return state;
          return state.copyWith(
            status: OverviewStatus.failure,
            errorMessage: error.toString(),
          );
        },
      );
    } finally {
      if (event.completer != null && !event.completer!.isCompleted) {
        event.completer!.complete();
      }
    }
  }

  Future<void> _onLoadPerformance(
    LoadPerformance event,
    Emitter<OverviewState> emit,
  ) async {
    if (state.performanceStatus != PerformanceStatus.success) {
      emit(state.copyWith(performanceStatus: PerformanceStatus.loading));
    }

    try {
      await emit.forEach<PerformanceEntity>(
        getPerformance(windowDays: event.windowDays),
        onData: (performance) {
          return state.copyWith(
            performanceStatus: PerformanceStatus.success,
            performance: performance,
            clearPerformanceError: true,
          );
        },
        onError: (error, stackTrace) {
          if (state.performanceStatus == PerformanceStatus.success) return state;
          return state.copyWith(
            performanceStatus: PerformanceStatus.failure,
            performanceErrorMessage: error.toString(),
          );
        },
      );
    } finally {
      if (event.completer != null && !event.completer!.isCompleted) {
        event.completer!.complete();
      }
    }
  }

  void _onUpdateReportDateRange(
    UpdateReportDateRange event,
    Emitter<OverviewState> emit,
  ) {
    emit(state.copyWith(
      reportFromDate: event.fromDate ?? state.reportFromDate,
      reportToDate: event.toDate ?? state.reportToDate,
    ));
    add(const LoadReport());
  }

  Future<void> _onLoadReport(
    LoadReport event,
    Emitter<OverviewState> emit,
  ) async {
    if (state.reportStatus != ReportStatus.success) {
      emit(state.copyWith(reportStatus: ReportStatus.loading));
    }

    DateTime fromDate = state.reportFromDate ?? DateTime.now().subtract(const Duration(days: 30));
    DateTime toDate = state.reportToDate ?? DateTime.now();

    if (state.reportFromDate == null || state.reportToDate == null) {
      emit(state.copyWith(
        reportFromDate: fromDate,
        reportToDate: toDate,
      ));
    }

    final dateFromStr = AppDateFormatter.formatIsoDate(fromDate);
    final dateToStr = AppDateFormatter.formatIsoDate(toDate);

    try {
      await emit.forEach<ReportEntity>(
        getReport(dateFrom: dateFromStr, dateTo: dateToStr),
        onData: (report) {
          // Sync state dates with API dates if we didn't have local dates picked
          DateTime? newFromDate = state.reportFromDate;
          DateTime? newToDate = state.reportToDate;
          if (newFromDate == null && report.dateFrom.isNotEmpty) {
            newFromDate = DateTime.tryParse(report.dateFrom);
          }
          if (newToDate == null && report.dateTo.isNotEmpty) {
            newToDate = DateTime.tryParse(report.dateTo);
          }

          return state.copyWith(
            reportStatus: ReportStatus.success,
            report: report,
            reportFromDate: newFromDate,
            reportToDate: newToDate,
            clearReportError: true,
          );
        },
        onError: (error, stackTrace) {
          if (state.reportStatus == ReportStatus.success) return state;
          return state.copyWith(
            reportStatus: ReportStatus.failure,
            reportErrorMessage: error.toString(),
          );
        },
      );
    } finally {
      if (event.completer != null && !event.completer!.isCompleted) {
        event.completer!.complete();
      }
    }
  }
}
