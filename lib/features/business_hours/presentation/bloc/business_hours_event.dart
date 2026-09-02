import 'dart:async';
import 'package:equatable/equatable.dart';
import '../../domain/entities/business_hours_entity.dart';

abstract class BusinessHoursEvent extends Equatable {
  const BusinessHoursEvent();

  @override
  List<Object?> get props => [];
}

class LoadBusinessHours extends BusinessHoursEvent {
  final Completer<void>? completer;

  const LoadBusinessHours({this.completer});

  @override
  List<Object?> get props => [completer];
}

class UpdateBusinessHours extends BusinessHoursEvent {
  const UpdateBusinessHours();
}

class EditDayHoursEvent extends BusinessHoursEvent {
  final String dayKey;
  final DayHoursEntity updatedDay;

  const EditDayHoursEvent({required this.dayKey, required this.updatedDay});

  @override
  List<Object?> get props => [dayKey, updatedDay];
}

class ResetUpdateStatus extends BusinessHoursEvent {}

class InitEditBusinessHoursForm extends BusinessHoursEvent {
  final String dayKey;
  final Map<String, DayHoursEntity> editableDays;

  const InitEditBusinessHoursForm({
    required this.dayKey,
    required this.editableDays,
  });

  @override
  List<Object?> get props => [dayKey, editableDays];
}

class UpdateEditBusinessHoursForm extends BusinessHoursEvent {
  final DayHoursEntity? updatedDay;
  final bool? applyToWeekdays;

  const UpdateEditBusinessHoursForm({this.updatedDay, this.applyToWeekdays});

  @override
  List<Object?> get props => [updatedDay, applyToWeekdays];
}

class SaveEditBusinessHoursForm extends BusinessHoursEvent {
  final String dayKey;

  const SaveEditBusinessHoursForm({required this.dayKey});

  @override
  List<Object?> get props => [dayKey];
}
