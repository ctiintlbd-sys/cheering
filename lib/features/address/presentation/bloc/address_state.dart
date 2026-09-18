import 'package:equatable/equatable.dart';

import '../../domain/entities/address_entity.dart';
import '../../domain/entities/map_location_entities.dart';

enum AddressStatus { initial, loading, success, failure }

enum AddressMutationStatus { initial, loading, success, failure }

class AddressState extends Equatable {
  const AddressState({
    this.status = AddressStatus.initial,
    this.mutationStatus = AddressMutationStatus.initial,
    this.addresses = const [],
    this.errorMessage,
    this.currentLocationAddress,
    this.isFetchingLocation = true,
    this.activeDefaultId,

    // Form State
    this.formType = AddressType.home,
    this.formIsDefault = false,
    this.formLocation,

    // Map State
    this.isPinMoving = false,
    this.mapAddress = MapLocationDefaults.locatingLabel,
    this.mapArea = '',
    this.mapSearchResults = const [],
    this.isMapSearchLoading = false,
    this.showMapSearchResults = false,
  });

  final AddressStatus status;
  final AddressMutationStatus mutationStatus;
  final List<AddressEntity> addresses;
  final String? errorMessage;
  
  final AddressEntity? currentLocationAddress;
  final bool isFetchingLocation;
  final String? activeDefaultId;

  // Form State
  final AddressType formType;
  final bool formIsDefault;
  final AddressEntity? formLocation;

  // Map State
  final bool isPinMoving;
  final String mapAddress;
  final String mapArea;
  final List<MapSearchResult> mapSearchResults;
  final bool isMapSearchLoading;
  final bool showMapSearchResults;

  bool get isLoading => status == AddressStatus.loading && addresses.isEmpty;
  bool get isSaving => mutationStatus == AddressMutationStatus.loading;

  List<AddressEntity> get displayAddresses {
    final List<AddressEntity> list = [];
    if (currentLocationAddress != null) {
      list.add(currentLocationAddress!.copyWith(
        isDefault: activeDefaultId == 'current_location',
      ));
    }
    for (final addr in addresses) {
      list.add(addr.copyWith(
        isDefault: activeDefaultId == addr.id,
      ));
    }
    return list;
  }

  AddressEntity? get activeAddress {
    final actives = displayAddresses.where((a) => a.isDefault);
    return actives.isNotEmpty ? actives.first : null;
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

    AddressType? formType,
    bool? formIsDefault,
    AddressEntity? formLocation,

    bool? isPinMoving,
    String? mapAddress,
    String? mapArea,
    List<MapSearchResult>? mapSearchResults,
    bool? isMapSearchLoading,
    bool? showMapSearchResults,
  }) {
    return AddressState(
      status: status ?? this.status,
      mutationStatus: mutationStatus ?? this.mutationStatus,
      addresses: addresses ?? this.addresses,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      currentLocationAddress: currentLocationAddress ?? this.currentLocationAddress,
      isFetchingLocation: isFetchingLocation ?? this.isFetchingLocation,
      activeDefaultId: activeDefaultId ?? this.activeDefaultId,

      formType: formType ?? this.formType,
      formIsDefault: formIsDefault ?? this.formIsDefault,
      formLocation: formLocation ?? this.formLocation,

      isPinMoving: isPinMoving ?? this.isPinMoving,
      mapAddress: mapAddress ?? this.mapAddress,
      mapArea: mapArea ?? this.mapArea,
      mapSearchResults: mapSearchResults ?? this.mapSearchResults,
      isMapSearchLoading: isMapSearchLoading ?? this.isMapSearchLoading,
      showMapSearchResults: showMapSearchResults ?? this.showMapSearchResults,
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

        formType,
        formIsDefault,
        formLocation,

        isPinMoving,
        mapAddress,
        mapArea,
        mapSearchResults,
        isMapSearchLoading,
        showMapSearchResults,
      ];
}
