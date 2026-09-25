import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/active_location_service.dart';
import '../../../../core/services/current_location_service.dart';
import '../../../../core/services/map_location_service.dart';
import '../../domain/entities/address_entity.dart';
import '../../domain/entities/map_location_entities.dart';
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
    required this._activeLocationService,
    required this._currentLocationService,
    required this._mapLocationService,
  }) : super(const AddressState()) {
    // RefreshAddressesRequested extends LoadAddressesRequested, so both share
    // one restartable stream and a refresh cancels a load still in flight.
    on<LoadAddressesRequested>(_onLoadAddresses, transformer: restartable());
    on<DeleteAddressRequested>(_onDeleteAddress);
    on<SetDefaultAddressRequested>(_onSetDefaultAddress);
    on<SaveAddressRequested>(_onSaveAddress);
    on<ResetAddressMutationStatus>(_onResetMutationStatus);
    on<InitializeAddressScreenData>(_onInitializeAddressScreenData);
    on<UpdateLocalCurrentLocation>(_onUpdateLocalCurrentLocation);
    on<UpdateActiveDefaultId>(_onUpdateActiveDefaultId);
    on<ClearAddressesEvent>(_onClearAddresses);
  }

  /// A cached GPS fix this recent is good enough for the current-location row;
  /// a cold fix can take several seconds.
  static const Duration _locationCacheAge = Duration(minutes: 5);

  final GetAddressesUseCase _getAddressesUseCase;
  final CreateAddressUseCase _createAddressUseCase;
  final UpdateAddressUseCase _updateAddressUseCase;
  final DeleteAddressUseCase _deleteAddressUseCase;
  final SetDefaultAddressUseCase _setDefaultAddressUseCase;
  final ActiveLocationService _activeLocationService;
  final CurrentLocationService _currentLocationService;
  final MapLocationService _mapLocationService;

  Future<void> _onLoadAddresses(
    LoadAddressesRequested event,
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
        // Keep showing what we already have rather than replacing it with an
        // error the user can't act on.
        onError: (error, stackTrace) => state.addresses.isNotEmpty
            ? state
            : state.copyWith(
                status: AddressStatus.failure,
                errorMessage: error.toString(),
              ),
      );
    } catch (e) {
      // Reached only if opening the stream itself throws; errors on the stream
      // go through onError above.
      if (state.addresses.isEmpty) {
        emit(
          state.copyWith(
            status: AddressStatus.failure,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }

  Future<void> _onDeleteAddress(
    DeleteAddressRequested event,
    Emitter<AddressState> emit,
  ) {
    return _runMutation(emit, () => _deleteAddressUseCase(event.id));
  }

  Future<void> _onSetDefaultAddress(
    SetDefaultAddressRequested event,
    Emitter<AddressState> emit,
  ) {
    return _runMutation(emit, () => _setDefaultAddressUseCase(event.id));
  }

  Future<void> _onSaveAddress(
    SaveAddressRequested event,
    Emitter<AddressState> emit,
  ) async {
    emit(
      state.copyWith(
        mutationStatus: AddressMutationStatus.loading,
        clearError: true,
      ),
    );
    try {
      final id = event.addressId;
      if (id != null) {
        await _updateAddressUseCase(id, event.params);
      } else {
        final newAddress = await _createAddressUseCase(event.params);
        add(UpdateActiveDefaultId(newAddress.id));
      }
      add(const RefreshAddressesRequested());
      emit(state.copyWith(mutationStatus: AddressMutationStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          mutationStatus: AddressMutationStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _runMutation(
    Emitter<AddressState> emit,
    Future<void> Function() action,
  ) async {
    emit(
      state.copyWith(
        mutationStatus: AddressMutationStatus.loading,
        clearError: true,
      ),
    );
    try {
      await action();
      add(const RefreshAddressesRequested());
      emit(state.copyWith(mutationStatus: AddressMutationStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          mutationStatus: AddressMutationStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onResetMutationStatus(
    ResetAddressMutationStatus event,
    Emitter<AddressState> emit,
  ) {
    emit(
      state.copyWith(
        mutationStatus: AddressMutationStatus.initial,
        clearError: true,
      ),
    );
  }

  Future<void> _onInitializeAddressScreenData(
    InitializeAddressScreenData event,
    Emitter<AddressState> emit,
  ) async {
    final activeId =
        _activeLocationService.activeAddress?.id ??
        AddressEntity.currentLocationId;
    emit(state.copyWith(activeDefaultId: activeId, isFetchingLocation: true));

    // Resolve first, then read `state`. Dart evaluates the receiver before the
    // arguments, so inlining the await would copy a snapshot taken before the
    // GPS wait and wipe any addresses that loaded during it.
    final currentLocation = await _resolveCurrentLocation(activeId);

    emit(
      state.copyWith(
        currentLocationAddress: currentLocation,
        isFetchingLocation: false,
      ),
    );
  }

  Future<AddressEntity> _resolveCurrentLocation(String activeId) async {
    final isDefault = activeId == AddressEntity.currentLocationId;

    try {
      final result = await _currentLocationService.fetchCurrentLocation(
        maxCacheAge: _locationCacheAge,
      );
      final latLng = result.latLng;
      if (latLng == null) return _unresolvedCurrentLocation(isDefault);

      final outcome = await _mapLocationService.reverseGeocode(
        latLng,
        ignoreDistanceCheck: true,
      );
      final snapshot = outcome is ReverseGeocodeResolved
          ? outcome.snapshot
          : null;
      if (snapshot == null) {
        debugPrint('[AddressBloc] have a fix but no address for it');
      }

      // The coordinates are real even when the address lookup fails, so keep
      // them — the row stays usable instead of dropping to the placeholder.
      return AddressEntity(
        id: AddressEntity.currentLocationId,
        type: AddressType.other,
        label: snapshot?.area ?? 'Current Location',
        streetAddress: snapshot?.address ?? MapLocationDefaults.unknownLabel,
        latitude: latLng.latitude,
        longitude: latLng.longitude,
        isDefault: isDefault,
      );
    } catch (e) {
      debugPrint('[AddressBloc] current location lookup threw: $e');
      return _unresolvedCurrentLocation(isDefault);
    }
  }

  AddressEntity _unresolvedCurrentLocation(bool isDefault) {
    return AddressEntity(
      id: AddressEntity.currentLocationId,
      type: AddressType.other,
      label: 'Current Location',
      streetAddress: 'Tap to pick location',
      latitude: 0.0,
      longitude: 0.0,
      isDefault: isDefault,
    );
  }

  void _onUpdateLocalCurrentLocation(
    UpdateLocalCurrentLocation event,
    Emitter<AddressState> emit,
  ) {
    emit(
      state.copyWith(
        activeDefaultId: AddressEntity.currentLocationId,
        currentLocationAddress: event.address,
      ),
    );
  }

  void _onUpdateActiveDefaultId(
    UpdateActiveDefaultId event,
    Emitter<AddressState> emit,
  ) {
    emit(state.copyWith(activeDefaultId: event.id));
  }

  void _onClearAddresses(
    ClearAddressesEvent event,
    Emitter<AddressState> emit,
  ) {
    emit(const AddressState());
    add(const InitializeAddressScreenData());
  }

  @override
  void onChange(Change<AddressState> change) {
    super.onChange(change);

    final previous = change.currentState;
    final next = change.nextState;
    final selectionChanged =
        previous.activeDefaultId != next.activeDefaultId ||
        previous.currentLocationAddress != next.currentLocationAddress ||
        previous.addresses != next.addresses;
    if (!selectionChanged) return;

    final active = next.activeAddress;
    if (active != null) _activeLocationService.setActiveAddress(active);
  }

  @override
  Future<void> close() {
    _mapLocationService.dispose();
    return super.close();
  }
}
