import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/address_entity.dart';
import '../../../../core/services/active_location_service.dart';
import '../../../../core/services/current_location_service.dart';
import '../../../../core/services/map_location_service.dart';
import '../../../../core/di/service_locator.dart';
import '../../domain/usecases/create_address_usecase.dart';
import '../../domain/usecases/delete_address_usecase.dart';
import '../../domain/usecases/get_addresses_usecase.dart';
import '../../domain/usecases/set_default_address_usecase.dart';
import '../../domain/usecases/update_address_usecase.dart';
import 'address_event.dart';
import 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  AddressBloc({
    required this._getAddressesUseCase,
    required this._createAddressUseCase,
    required this._updateAddressUseCase,
    required this._deleteAddressUseCase,
    required this._setDefaultAddressUseCase,
  })  : super(const AddressState()) {
    on<LoadAddressesRequested>(
      _onLoadAddresses,
      transformer: restartable(),
    );
    on<RefreshAddressesRequested>(
      _onLoadAddresses,
      transformer: restartable(),
    );
    on<DeleteAddressRequested>(_onDeleteAddress);
    on<SetDefaultAddressRequested>(_onSetDefaultAddress);
    on<SaveAddressRequested>(_onSaveAddress);
    on<ResetAddressMutationStatus>(
      (event, emit) => emit(
        state.copyWith(mutationStatus: AddressMutationStatus.initial, clearError: true),
      ),
    );
    on<InitializeAddressScreenData>(_onInitializeAddressScreenData);
    on<UpdateLocalCurrentLocation>(_onUpdateLocalCurrentLocation);
    on<UpdateActiveDefaultId>(_onUpdateActiveDefaultId);
  }

  final GetAddressesUseCase _getAddressesUseCase;
  final CreateAddressUseCase _createAddressUseCase;
  final UpdateAddressUseCase _updateAddressUseCase;
  final DeleteAddressUseCase _deleteAddressUseCase;
  final SetDefaultAddressUseCase _setDefaultAddressUseCase;

  Future<void> _onLoadAddresses(
    AddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    if (state.addresses.isEmpty) {
      emit(state.copyWith(status: AddressStatus.loading, clearError: true));
    }

    try {
      await emit.forEach<List<AddressEntity>>(
        _getAddressesUseCase(),
        onData: (addresses) => state.copyWith(
          status: AddressStatus.success,
          addresses: addresses,
          clearError: true,
        ),
        onError: (error, stackTrace) {
          if (state.addresses.isNotEmpty) return state;
          return state.copyWith(
            status: AddressStatus.failure,
            errorMessage: error.toString(),
          );
        },
      );
    } catch (e) {
      if (state.addresses.isEmpty) {
        emit(state.copyWith(
          status: AddressStatus.failure,
          errorMessage: e.toString(),
        ));
      }
    }
  }

  Future<void> _onDeleteAddress(
    DeleteAddressRequested event,
    Emitter<AddressState> emit,
  ) async {
    emit(state.copyWith(mutationStatus: AddressMutationStatus.loading, clearError: true));
    try {
      await _deleteAddressUseCase(event.id);
      add(const RefreshAddressesRequested());
      emit(state.copyWith(mutationStatus: AddressMutationStatus.success));
    } catch (e) {
      emit(state.copyWith(
        mutationStatus: AddressMutationStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onSetDefaultAddress(
    SetDefaultAddressRequested event,
    Emitter<AddressState> emit,
  ) async {
    emit(state.copyWith(mutationStatus: AddressMutationStatus.loading, clearError: true));
    try {
      await _setDefaultAddressUseCase(event.id);
      add(const RefreshAddressesRequested());
      emit(state.copyWith(mutationStatus: AddressMutationStatus.success));
    } catch (e) {
      emit(state.copyWith(
        mutationStatus: AddressMutationStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onSaveAddress(
    SaveAddressRequested event,
    Emitter<AddressState> emit,
  ) async {
    emit(state.copyWith(mutationStatus: AddressMutationStatus.loading, clearError: true));
    try {
      if (event.addressId != null) {
        await _updateAddressUseCase(event.addressId!, event.params);
      } else {
        await _createAddressUseCase(event.params);
      }
      add(const RefreshAddressesRequested());
      emit(state.copyWith(mutationStatus: AddressMutationStatus.success));
    } catch (e) {
      emit(state.copyWith(
        mutationStatus: AddressMutationStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
  Future<void> _onInitializeAddressScreenData(
    InitializeAddressScreenData event,
    Emitter<AddressState> emit,
  ) async {
    final activeId = getIt<ActiveLocationService>().activeAddress?.id ?? 'current_location';
    emit(state.copyWith(
      activeDefaultId: activeId,
      isFetchingLocation: true,
    ));

    try {
      final result = await getIt<CurrentLocationService>().fetchCurrentLocation(
        requestPermission: false,
      );
      if (result.isSuccess && result.latLng != null) {
        final snapshot = await MapLocationService().reverseGeocode(result.latLng!);
        if (snapshot != null) {
          final currentLoc = AddressEntity(
            id: 'current_location',
            type: AddressType.other,
            label: snapshot.area,
            streetAddress: snapshot.address,
            latitude: snapshot.position.latitude,
            longitude: snapshot.position.longitude,
            isDefault: activeId == 'current_location',
          );
          emit(state.copyWith(
            currentLocationAddress: currentLoc,
            isFetchingLocation: false,
          ));
          return;
        }
      }
    } catch (_) {}

    // Fallback if failed
    final fallbackLoc = AddressEntity(
      id: 'current_location',
      type: AddressType.other,
      label: 'Current Location',
      streetAddress: 'Tap to pick location',
      latitude: 0.0,
      longitude: 0.0,
      isDefault: activeId == 'current_location',
    );
    emit(state.copyWith(
      currentLocationAddress: fallbackLoc,
      isFetchingLocation: false,
    ));
  }

  void _onUpdateLocalCurrentLocation(
    UpdateLocalCurrentLocation event,
    Emitter<AddressState> emit,
  ) {
    emit(state.copyWith(
      activeDefaultId: 'current_location',
      currentLocationAddress: event.address,
    ));
  }

  void _onUpdateActiveDefaultId(
    UpdateActiveDefaultId event,
    Emitter<AddressState> emit,
  ) {
    emit(state.copyWith(
      activeDefaultId: event.id,
    ));
  }

  @override
  void onChange(Change<AddressState> change) {
    super.onChange(change);
    final active = change.nextState.activeAddress;
    if (active != null) {
      getIt<ActiveLocationService>().setActiveAddress(active);
    }
  }
}
