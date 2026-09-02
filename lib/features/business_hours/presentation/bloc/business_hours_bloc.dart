import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import '../../domain/usecases/business_hours_usecases.dart';
import '../../domain/entities/business_hours_entity.dart';
import 'business_hours_event.dart';
import 'business_hours_state.dart';

class BusinessHoursBloc extends Bloc<BusinessHoursEvent, BusinessHoursState> {
  final GetBusinessHoursUseCase _getBusinessHours;
  final UpdateBusinessHoursUseCase _updateBusinessHours;

  BusinessHoursBloc({
    required GetBusinessHoursUseCase getBusinessHours,
    required UpdateBusinessHoursUseCase updateBusinessHours,
  })  : _getBusinessHours = getBusinessHours,
        _updateBusinessHours = updateBusinessHours,
        super(const BusinessHoursState()) {
    on<LoadBusinessHours>(_onLoadBusinessHours, transformer: restartable());
    on<UpdateBusinessHours>(_onUpdateBusinessHours, transformer: sequential());
    on<EditDayHoursEvent>(_onEditDayHoursEvent);
    on<ResetUpdateStatus>(_onResetUpdateStatus);
    on<InitEditBusinessHoursForm>(_onInitEditBusinessHoursForm);
    on<UpdateEditBusinessHoursForm>(_onUpdateEditBusinessHoursForm);
    on<SaveEditBusinessHoursForm>(_onSaveEditBusinessHoursForm);
  }

  Future<void> _onLoadBusinessHours(
    LoadBusinessHours event,
    Emitter<BusinessHoursState> emit,
  ) async {
    if (state.fetchStatus != BusinessHoursStatus.success) {
      emit(state.copyWith(fetchStatus: BusinessHoursStatus.loading));
    }

    try {
      final data = await _getBusinessHours();
      emit(state.copyWith(
        fetchStatus: BusinessHoursStatus.success,
        businessHoursData: data,
        editableDays: Map.from(data.days), // Initialize editable days
        clearError: true,
      ));
    } catch (e) {
      if (state.fetchStatus != BusinessHoursStatus.success) {
        emit(
          state.copyWith(
            fetchStatus: BusinessHoursStatus.failure,
            errorMessage: e.toString(),
          ),
        );
      }
    } finally {
      if (event.completer != null && !event.completer!.isCompleted) {
        event.completer!.complete();
      }
    }
  }

  Future<void> _onUpdateBusinessHours(
    UpdateBusinessHours event,
    Emitter<BusinessHoursState> emit,
  ) async {
    if (state.editableDays == null) return;
    
    // Sanitize days to ensure open days have valid times
    final sanitizedDays = Map<String, DayHoursEntity>.from(state.editableDays!);
    for (final entry in sanitizedDays.entries) {
      if (entry.value.isOpen) {
        var day = entry.value;
        if (day.opensAt.isEmpty) day = day.copyWith(opensAt: '10:00');
        if (day.closesAt.isEmpty) day = day.copyWith(closesAt: '22:00');
        sanitizedDays[entry.key] = day;
      }
    }
    
    emit(state.copyWith(
      updateStatus: BusinessHoursStatus.loading,
      editableDays: sanitizedDays,
    ));

    try {
      await _updateBusinessHours(sanitizedDays);
      
      // Update local data optimistically
      if (state.businessHoursData != null) {
        final updatedData = state.businessHoursData!.copyWith(
          days: sanitizedDays,
          isConfigured: true, 
        );
        emit(state.copyWith(
          updateStatus: BusinessHoursStatus.success,
          businessHoursData: updatedData,
          clearError: true,
        ));
      } else {
        emit(state.copyWith(
          updateStatus: BusinessHoursStatus.success,
          clearError: true,
        ));
      }
    } catch (e) {
      emit(
        state.copyWith(
          updateStatus: BusinessHoursStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onEditDayHoursEvent(
    EditDayHoursEvent event,
    Emitter<BusinessHoursState> emit,
  ) {
    if (state.editableDays != null) {
      final updatedDays = Map<String, DayHoursEntity>.from(state.editableDays!);
      updatedDays[event.dayKey] = event.updatedDay;
      emit(state.copyWith(editableDays: updatedDays));
    }
  }

  void _onResetUpdateStatus(
    ResetUpdateStatus event,
    Emitter<BusinessHoursState> emit,
  ) {
    emit(state.copyWith(updateStatus: BusinessHoursStatus.initial));
  }

  void _onInitEditBusinessHoursForm(
    InitEditBusinessHoursForm event,
    Emitter<BusinessHoursState> emit,
  ) {
    DayHoursEntity? targetDay;
    if (event.editableDays.containsKey(event.dayKey)) {
      targetDay = event.editableDays[event.dayKey];
    } else {
      targetDay = const DayHoursEntity(isOpen: true, opensAt: '10:00', closesAt: '22:00');
    }

    if (targetDay != null && targetDay.isOpen) {
      if (targetDay.opensAt.isEmpty) targetDay = targetDay.copyWith(opensAt: '10:00');
      if (targetDay.closesAt.isEmpty) targetDay = targetDay.copyWith(closesAt: '22:00');
    }

    emit(state.copyWith(
      editingDayHours: targetDay,
      editableDays: event.editableDays, // IMPORTANT: Save the map so we can submit later!
      applyToWeekdays: false,
    ));
  }

  void _onUpdateEditBusinessHoursForm(
    UpdateEditBusinessHoursForm event,
    Emitter<BusinessHoursState> emit,
  ) {
    var updated = event.updatedDay;
    
    // Automatically set default times if the user turns the day ON but times are empty
    if (updated != null && updated.isOpen) {
      if (updated.opensAt.isEmpty) updated = updated.copyWith(opensAt: '10:00');
      if (updated.closesAt.isEmpty) updated = updated.copyWith(closesAt: '22:00');
    }

    emit(state.copyWith(
      editingDayHours: updated,
      applyToWeekdays: event.applyToWeekdays,
    ));
  }

  void _onSaveEditBusinessHoursForm(
    SaveEditBusinessHoursForm event,
    Emitter<BusinessHoursState> emit,
  ) {
    if (state.editingDayHours == null || state.editableDays == null) return;

    final updatedDays = Map<String, DayHoursEntity>.from(state.editableDays!);
    
    // Update the current day
    updatedDays[event.dayKey] = state.editingDayHours!;

    // Update weekdays if applied
    if (state.applyToWeekdays) {
      final weekdays = ['mon', 'tue', 'wed', 'thu', 'fri'];
      for (final day in weekdays) {
        if (day != event.dayKey) {
          updatedDays[day] = state.editingDayHours!;
        }
      }
    }

    emit(state.copyWith(editableDays: updatedDays));
    
    // Trigger API save
    add(const UpdateBusinessHours());
  }
}
