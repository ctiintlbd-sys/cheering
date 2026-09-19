import '../../features/address/domain/entities/address_entity.dart';

/// Holds the address the rest of the app should deliver to.
///
/// `AddressBloc` is the source of truth and pushes into this; it exists so
/// non-address features can read the selection without depending on the bloc.
class ActiveLocationService {
  AddressEntity? _activeAddress;

  AddressEntity? get activeAddress => _activeAddress;

  void setActiveAddress(AddressEntity address) => _activeAddress = address;

  void clear() => _activeAddress = null;
}
