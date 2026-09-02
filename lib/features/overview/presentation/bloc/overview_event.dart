import 'dart:async';
import 'package:equatable/equatable.dart';

abstract class OverviewEvent extends Equatable {
  const OverviewEvent();

  @override
  List<Object?> get props => [];
}

class LoadOverview extends OverviewEvent {
  final Completer<void>? completer;
  const LoadOverview({this.completer});

  @override
  List<Object?> get props => [completer];
}

class LoadPerformance extends OverviewEvent {
  final Completer<void>? completer;
  final int windowDays;

  const LoadPerformance({this.completer, this.windowDays = 30});

  @override
  List<Object?> get props => [completer, windowDays];
}

class LoadReport extends OverviewEvent {
  final Completer<void>? completer;

  const LoadReport({this.completer});

  @override
  List<Object?> get props => [completer];
}

class UpdateReportDateRange extends OverviewEvent {
  final DateTime? fromDate;
  final DateTime? toDate;

  const UpdateReportDateRange({this.fromDate, this.toDate});

  @override
  List<Object?> get props => [fromDate, toDate];
}
