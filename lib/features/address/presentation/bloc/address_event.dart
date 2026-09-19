import 'package:equatable/equatable.dart';

import '../../domain/entities/address_entity.dart';
import '../../domain/entities/address_params.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object?> get props => [];
}

class LoadAddressesRequested extends AddressEvent {
  const LoadAddressesRequested();
}

/// A refresh is a reload, so it shares `LoadAddressesRequested`'s handler and
/// its restartable transformer instead of racing against it.
class RefreshAddressesRequested extends LoadAddressesRequested {
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
  const SaveAddressRequested({required this.params, this.addressId});

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

class ClearAddressesEvent extends AddressEvent {
  const ClearAddressesEvent();
}
