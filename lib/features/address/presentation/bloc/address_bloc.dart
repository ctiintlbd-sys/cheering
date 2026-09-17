import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/address_entity.dart';
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
}
