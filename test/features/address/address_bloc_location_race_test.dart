import 'package:cheering/core/services/current_location_service.dart';
import 'package:cheering/core/services/map_location_service.dart';
import 'package:cheering/core/services/active_location_service.dart';
import 'package:cheering/features/address/domain/entities/address_entity.dart';
import 'package:cheering/features/address/domain/entities/address_params.dart';
import 'package:cheering/features/address/domain/entities/map_location_entities.dart';
import 'package:cheering/features/address/domain/repositories/i_address_repository.dart';
import 'package:cheering/features/address/domain/usecases/create_address_usecase.dart';
import 'package:cheering/features/address/domain/usecases/delete_address_usecase.dart';
import 'package:cheering/features/address/domain/usecases/get_addresses_usecase.dart';
import 'package:cheering/features/address/domain/usecases/set_default_address_usecase.dart';
import 'package:cheering/features/address/domain/usecases/update_address_usecase.dart';
import 'package:cheering/features/address/presentation/bloc/address_bloc.dart';
import 'package:cheering/features/address/presentation/bloc/address_event.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const _saved = AddressEntity(
  id: '1',
  type: AddressType.home,
  streetAddress: 'Saved street',
  latitude: 23.8,
  longitude: 90.4,
  isDefault: false,
);

class _FakeRepository implements IAddressRepository {
  _FakeRepository(this.addressDelay);

  final Duration addressDelay;

  @override
  Stream<List<AddressEntity>> getAddresses() async* {
    await Future<void>.delayed(addressDelay);
    yield const [_saved];
  }

  @override
  Future<AddressEntity> createAddress(AddressParams params) async => _saved;

  @override
  Future<AddressEntity> updateAddress(String id, AddressParams params) async =>
      _saved;

  @override
  Future<void> deleteAddress(String id) async {}

  @override
  Future<AddressEntity> setDefaultAddress(String id) async => _saved;
}

/// Stands in for a slow cold GPS fix, which is what Android hits.
class _SlowLocationService extends CurrentLocationService {
  _SlowLocationService(this.delay);

  final Duration delay;

  @override
  Future<CurrentLocationResult> fetchCurrentLocation({
    LocationAccuracy accuracy = LocationAccuracy.best,
    bool requestPermission = true,
    Duration? maxCacheAge,
  }) async {
    await Future<void>.delayed(delay);
    return CurrentLocationResult.success(const LatLng(23.81, 90.41));
  }
}

class _StubMapService extends MapLocationService {
  @override
  Future<ReverseGeocodeOutcome> reverseGeocode(
    LatLng position, {
    bool ignoreDistanceCheck = false,
  }) async => const ReverseGeocodeFailed();

  @override
  void dispose() {}
}

AddressBloc _buildBloc({
  required Duration addressDelay,
  required Duration gpsDelay,
}) {
  final repository = _FakeRepository(addressDelay);
  return AddressBloc(
    getAddressesUseCase: GetAddressesUseCase(repository),
    createAddressUseCase: CreateAddressUseCase(repository),
    updateAddressUseCase: UpdateAddressUseCase(repository),
    deleteAddressUseCase: DeleteAddressUseCase(repository),
    setDefaultAddressUseCase: SetDefaultAddressUseCase(repository),
    activeLocationService: ActiveLocationService(),
    currentLocationService: _SlowLocationService(gpsDelay),
    mapLocationService: _StubMapService(),
  );
}

void main() {
  test(
    'addresses that arrive during the GPS wait are not wiped by the location emit',
    () async {
      final bloc = _buildBloc(
        addressDelay: const Duration(milliseconds: 20),
        gpsDelay: const Duration(milliseconds: 200),
      );

      bloc.add(const InitializeAddressScreenData());
      bloc.add(const LoadAddressesRequested());

      await Future<void>.delayed(const Duration(milliseconds: 500));

      expect(bloc.state.addresses, [_saved]);
      expect(bloc.state.isFetchingLocation, isFalse);
      expect(bloc.state.currentLocationAddress, isNotNull);

      await bloc.close();
    },
  );

  test('the reverse ordering (fast GPS) also keeps both pieces of state', () async {
    final bloc = _buildBloc(
      addressDelay: const Duration(milliseconds: 200),
      gpsDelay: const Duration(milliseconds: 20),
    );

    bloc.add(const InitializeAddressScreenData());
    bloc.add(const LoadAddressesRequested());

    await Future<void>.delayed(const Duration(milliseconds: 500));

    expect(bloc.state.addresses, [_saved]);
    expect(bloc.state.currentLocationAddress, isNotNull);

    await bloc.close();
  });
}
