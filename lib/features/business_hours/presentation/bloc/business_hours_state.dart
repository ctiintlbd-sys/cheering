import 'package:equatable/equatable.dart';
import '../../domain/entities/business_hours_entity.dart';

enum BusinessHoursStatus { initial, loading, success, failure }

class BusinessHoursState extends Equatable {
  final BusinessHoursStatus fetchStatus;
  final BusinessHoursDataEntity? businessHoursData;
  final BusinessHoursStatus updateStatus;
  final String? errorMessage;
  
  // For the edit screen: to hold temporary unsaved edits
  final Map<String, DayHoursEntity>? editableDays;
  
  // Specific properties for EditBusinessHoursScreen Form
  final DayHoursEntity? editingDayHours;
  final bool applyToWeekdays;

  const BusinessHoursState({
    this.fetchStatus = BusinessHoursStatus.initial,
    this.businessHoursData,
    this.updateStatus = BusinessHoursStatus.initial,
    this.errorMessage,
    this.editableDays,
    this.editingDayHours,
    this.applyToWeekdays = false,
  });

  BusinessHoursState copyWith({
    BusinessHoursStatus? fetchStatus,
    BusinessHoursDataEntity? businessHoursData,
    BusinessHoursStatus? updateStatus,
    String? errorMessage,
    bool clearError = false,
    Map<String, DayHoursEntity>? editableDays,
    DayHoursEntity? editingDayHours,
    bool? applyToWeekdays,
  }) {
    return BusinessHoursState(
      fetchStatus: fetchStatus ?? this.fetchStatus,
      businessHoursData: businessHoursData ?? this.businessHoursData,
      updateStatus: updateStatus ?? this.updateStatus,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      editableDays: editableDays ?? this.editableDays,
      editingDayHours: editingDayHours ?? this.editingDayHours,
      applyToWeekdays: applyToWeekdays ?? this.applyToWeekdays,
    );
  }

  @override
  List<Object?> get props => [
        fetchStatus,
        businessHoursData,
        updateStatus,
        errorMessage,
        editableDays,
        editingDayHours,
        applyToWeekdays,
      ];
}
