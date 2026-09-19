import 'package:equatable/equatable.dart';

import '../../domain/entities/address_entity.dart';

enum AddressStatus { initial, loading, success, failure }

enum AddressMutationStatus { initial, loading, success, failure }

/// The saved-address list and the current-location row derived from GPS.
///
/// The map picker and the add/edit form keep their own state in
/// `MapPickerCubit` / `AddressFormCubit`, so nothing here churns while the user
/// pans a map or types in a form field.
class AddressState extends Equatable {
  const AddressState({
    this.status = AddressStatus.initial,
    this.mutationStatus = AddressMutationStatus.initial,
    this.addresses = const [],
    this.errorMessage,
    this.currentLocationAddress,
    this.isFetchingLocation = true,
    this.activeDefaultId,
  });

  final AddressStatus status;
  final AddressMutationStatus mutationStatus;
  final List<AddressEntity> addresses;
  final String? errorMessage;

  final AddressEntity? currentLocationAddress;
  final bool isFetchingLocation;
  final String? activeDefaultId;

  bool get isLoading => status == AddressStatus.loading && addresses.isEmpty;

  bool get isSaving => mutationStatus == AddressMutationStatus.loading;

  /// The current-location row followed by the saved addresses, each carrying an
  /// `isDefault` flag that reflects the locally selected id.
  List<AddressEntity> get displayAddresses {
    final list = <AddressEntity>[];

    final current = currentLocationAddress;
    if (current != null) {
      list.add(_withDefaultFlag(current, AddressEntity.currentLocationId));
    }
    for (final address in addresses) {
      list.add(_withDefaultFlag(address, address.id));
    }

    return list;
  }

  AddressEntity? get activeAddress {
    for (final address in displayAddresses) {
      if (address.isDefault) return address;
    }
    return null;
  }

  AddressEntity _withDefaultFlag(AddressEntity address, String id) {
    final isDefault = activeDefaultId == id;
    return address.isDefault == isDefault
        ? address
        : address.copyWith(isDefault: isDefault);
  }

  AddressState copyWith({
    AddressStatus? status,
    AddressMutationStatus? mutationStatus,
    List<AddressEntity>? addresses,
    String? errorMessage,
    bool clearError = false,
    AddressEntity? currentLocationAddress,
    bool? isFetchingLocation,
    String? activeDefaultId,
  }) {
    return AddressState(
      status: status ?? this.status,
      mutationStatus: mutationStatus ?? this.mutationStatus,
      addresses: addresses ?? this.addresses,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      currentLocationAddress:
          currentLocationAddress ?? this.currentLocationAddress,
      isFetchingLocation: isFetchingLocation ?? this.isFetchingLocation,
      activeDefaultId: activeDefaultId ?? this.activeDefaultId,
    );
  }

  @override
  List<Object?> get props => [
    status,
    mutationStatus,
    addresses,
    errorMessage,
    currentLocationAddress,
    isFetchingLocation,
    activeDefaultId,
  ];
}
