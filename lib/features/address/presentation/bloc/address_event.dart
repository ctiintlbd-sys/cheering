import '../../domain/entities/map_location_entities.dart';
import 'package:equatable/equatable.dart';

import '../../domain/usecases/address_params.dart';
import '../../domain/entities/address_entity.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object?> get props => [];
}

class LoadAddressesRequested extends AddressEvent {
  const LoadAddressesRequested();
}

class RefreshAddressesRequested extends AddressEvent {
  const RefreshAddressesRequested();
}

class DeleteAddressRequested extends AddressEvent {
  const DeleteAddressRequested(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

class SetDefaultAddressRequested extends AddressEvent {
  const SetDefaultAddressRequested(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

class SaveAddressRequested extends AddressEvent {
  const SaveAddressRequested({
    required this.params,
    this.addressId,
  });

  final AddressParams params;
  final String? addressId;

  @override
  List<Object?> get props => [params, addressId];
}

class ResetAddressMutationStatus extends AddressEvent {
  const ResetAddressMutationStatus();
}

class InitializeAddressScreenData extends AddressEvent {
  const InitializeAddressScreenData();
}

class UpdateLocalCurrentLocation extends AddressEvent {
  const UpdateLocalCurrentLocation(this.address);
  final AddressEntity address;

  @override
  List<Object?> get props => [address];
}

class UpdateActiveDefaultId extends AddressEvent {
  const UpdateActiveDefaultId(this.id);
  final String id;

  @override
  List<Object?> get props => [id];
}

// ─── Form Events ──────────────────────────────────────────────

class InitFormEvent extends AddressEvent {
  const InitFormEvent(this.address);
  final AddressEntity address;
  @override
  List<Object?> get props => [address];
}

class UpdateFormTypeEvent extends AddressEvent {
  const UpdateFormTypeEvent(this.type);
  final AddressType type;
  @override
  List<Object?> get props => [type];
}



class UpdateFormLocationEvent extends AddressEvent {
  const UpdateFormLocationEvent(this.location);
  final AddressEntity location;
  @override
  List<Object?> get props => [location];
}

// ─── Map Events ───────────────────────────────────────────────

class UpdateMapPinEvent extends AddressEvent {
  const UpdateMapPinEvent(this.isMoving);
  final bool isMoving;
  @override
  List<Object?> get props => [isMoving];
}

class UpdateMapAddressEvent extends AddressEvent {
  const UpdateMapAddressEvent(this.address, this.area);
  final String address;
  final String area;
  @override
  List<Object?> get props => [address, area];
}

class SetMapUnknownAddressEvent extends AddressEvent {
  const SetMapUnknownAddressEvent();
}

class ShowMapSearchLoadingEvent extends AddressEvent {
  const ShowMapSearchLoadingEvent();
}

class UpdateMapSearchResultsEvent extends AddressEvent {
  const UpdateMapSearchResultsEvent(this.results, this.show);
  final List<MapSearchResult> results;
  final bool show;
  @override
  List<Object?> get props => [results, show];
}

class ClearMapSearchResultsEvent extends AddressEvent {
  const ClearMapSearchResultsEvent();
}

class ShowMapSearchResultsEvent extends AddressEvent {
  const ShowMapSearchResultsEvent(this.show);
  final bool show;
  @override
  List<Object?> get props => [show];
}

class ClearAddressesEvent extends AddressEvent {
  const ClearAddressesEvent();
}
