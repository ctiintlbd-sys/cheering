import 'package:equatable/equatable.dart';

import '../../domain/usecases/address_params.dart';

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
