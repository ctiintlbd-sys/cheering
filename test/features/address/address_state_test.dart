import 'package:cheering/features/address/domain/entities/address_entity.dart';
import 'package:cheering/features/address/presentation/bloc/address_state.dart';
import 'package:flutter_test/flutter_test.dart';

AddressEntity _address({
  required String id,
  AddressType type = AddressType.home,
  String? apartment,
  String? streetAddress,
  String? landmark,
  String? city,
  String? label,
  bool isDefault = false,
}) {
  return AddressEntity(
    id: id,
    type: type,
    apartment: apartment,
    streetAddress: streetAddress,
    landmark: landmark,
    city: city,
    label: label,
    latitude: 23.79,
    longitude: 90.40,
    isDefault: isDefault,
  );
}

void main() {
  group('AddressState.displayAddresses', () {
    test('puts the current-location row before the saved addresses', () {
      final state = AddressState(
        currentLocationAddress: _address(id: AddressEntity.currentLocationId),
        addresses: [
          _address(id: 'a'),
          _address(id: 'b'),
        ],
      );

      expect(state.displayAddresses.map((a) => a.id), [
        AddressEntity.currentLocationId,
        'a',
        'b',
      ]);
    });

    test('marks only the locally selected id as default', () {
      final state = AddressState(
        activeDefaultId: 'b',
        currentLocationAddress: _address(
          id: AddressEntity.currentLocationId,
          isDefault: true,
        ),
        addresses: [
          _address(id: 'a', isDefault: true),
          _address(id: 'b'),
        ],
      );

      expect(
        state.displayAddresses.where((a) => a.isDefault).map((a) => a.id),
        ['b'],
      );
      expect(state.activeAddress?.id, 'b');
    });

    test('activeAddress is null when the selected id is not in the list', () {
      final state = AddressState(
        activeDefaultId: 'gone',
        addresses: [_address(id: 'a')],
      );

      expect(state.activeAddress, isNull);
    });

    test('reuses the entity when the default flag already matches', () {
      final saved = _address(id: 'a');
      final state = AddressState(activeDefaultId: 'other', addresses: [saved]);

      expect(state.displayAddresses.single, same(saved));
    });
  });

  group('AddressFormatting.formattedAddress', () {
    test('joins the parts it has, in order', () {
      final address = _address(
        id: 'a',
        apartment: 'House 12',
        streetAddress: 'Road 8',
        landmark: 'Blue gate',
        city: 'Dhaka',
      );

      expect(address.formattedAddress, 'House 12, Road 8, Blue gate, Dhaka');
    });

    test('drops the city when an earlier part already mentions it', () {
      final address = _address(
        id: 'a',
        streetAddress: 'Dhanmondi, Dhaka',
        city: 'Dhaka',
      );

      expect(address.formattedAddress, 'Dhanmondi, Dhaka');
    });

    test('falls back to the label when nothing else is set', () {
      expect(
        _address(id: 'a', label: 'Current Location').formattedAddress,
        'Current Location',
      );
    });

    test('is empty when there is nothing to show', () {
      expect(_address(id: 'a').formattedAddress, '');
    });
  });
}
