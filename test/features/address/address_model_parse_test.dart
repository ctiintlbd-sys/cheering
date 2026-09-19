import 'package:cheering/features/address/data/models/address_model.dart';
import 'package:cheering/features/address/domain/entities/address_entity.dart';
import 'package:flutter_test/flutter_test.dart';

/// Verbatim response from GET /addresses.
const _realPayload = {
  'success': true,
  'data': [
    {
      'id': 'c14f6c97-3dd4-4fea-931d-bc1769642767',
      'type': 'OTHER',
      'label': null,
      'street_address': 'string',
      'apartment': 'string',
      'landmark': 'string',
      'city': 'string',
      'postal_code': 'string',
      'contact_phone': 'string',
      'latitude': 90,
      'longitude': 23,
      'is_default': true,
    },
    {
      'id': '51478a17-fc15-4b5e-81be-525e32c57302',
      'type': 'HOME',
      'label': null,
      'street_address':
          '4, 4 Road # 28, Block # C, Banani, Dhaka 1213, Bangladesh, Gulshan, Dhaka, Gulshan',
      'apartment': '12',
      'landmark': '',
      'city': null,
      'postal_code': null,
      'contact_phone': '',
      'latitude': 23.793699894033406,
      'longitude': 90.40660008788109,
      'is_default': false,
    },
    {
      'id': 'bd4efaeb-e6fd-4167-8c20-2d8ee4428264',
      'type': 'OTHER',
      'label': null,
      'street_address': 'string',
      'apartment': 'string',
      'landmark': 'string',
      'city': 'string',
      'postal_code': 'string',
      'contact_phone': 'string',
      'latitude': 37.785833,
      'longitude': -122.406417,
      'is_default': false,
    },
    {
      'id': 'bc762bc9-5ec8-4591-bb5c-b098f9c7e6f0',
      'type': 'WORK',
      'label': null,
      'street_address': 'jdshkfjdsa',
      'apartment': null,
      'landmark': 'stringdsfhfgh',
      'city': 'stringhsdfhfg',
      'postal_code': null,
      'contact_phone': '+880string',
      'latitude': 23.810299872715827,
      'longitude': 90.41249994188549,
      'is_default': false,
    },
  ],
};

void main() {
  group('AddressModel.listFromJson', () {
    test('parses decimal coordinates sent as strings', () {
      final list = AddressModel.listFromJson({
        'data': [
          {
            'id': 1,
            'type': 'HOME',
            'latitude': '23.8103',
            'longitude': '90.4125',
            'is_default': true,
          },
        ],
      });

      expect(list, hasLength(1));
      expect(list.single.latitude, closeTo(23.8103, 1e-9));
      expect(list.single.longitude, closeTo(90.4125, 1e-9));
      expect(list.single.id, '1');
      expect(list.single.isDefault, isTrue);
    });

    test('parses coordinates sent as numbers', () {
      final list = AddressModel.listFromJson({
        'data': [
          {'id': 'a', 'type': 'WORK', 'latitude': 23, 'longitude': 90.5},
        ],
      });

      expect(list.single.latitude, 23.0);
      expect(list.single.longitude, 90.5);
    });

    test('reads a list nested one level deeper', () {
      final list = AddressModel.listFromJson({
        'data': {
          'addresses': [
            {'id': 'x', 'type': 'HOME', 'latitude': 1.0, 'longitude': 2.0},
          ],
        },
      });

      expect(list, hasLength(1));
      expect(list.single.id, 'x');
    });

    test('returns empty instead of throwing on an unexpected payload', () {
      expect(AddressModel.listFromJson({'data': null}), isEmpty);
      expect(AddressModel.listFromJson({}), isEmpty);
      expect(AddressModel.listFromJson(null), isEmpty);
    });

    test('parses the real backend payload', () {
      final list = AddressModel.listFromJson(_realPayload);

      expect(list, hasLength(4));

      expect(list.map((e) => e.type), [
        AddressType.other,
        AddressType.home,
        AddressType.other,
        AddressType.work,
      ]);

      // Whole numbers arrive as ints, so they must survive without a cast throw.
      expect(list[0].latitude, 90.0);
      expect(list[0].longitude, 23.0);
      expect(list[0].isDefault, isTrue);
      expect(list[0].id, 'c14f6c97-3dd4-4fea-931d-bc1769642767');

      expect(list[1].latitude, closeTo(23.793699894033406, 1e-12));
      expect(list[1].longitude, closeTo(90.40660008788109, 1e-12));
      expect(list[1].apartment, '12');
      expect(list[1].city, isNull);
      expect(list[1].isDefault, isFalse);

      // Negative longitudes must not be mangled.
      expect(list[2].longitude, closeTo(-122.406417, 1e-12));

      expect(list.every((e) => e.label == null), isTrue);
    });

    test('the real payload survives a cache round trip unchanged', () {
      final original = AddressModel.listFromJson(_realPayload);
      final envelope = {'data': original.map((e) => e.toJson()).toList()};

      expect(AddressModel.listFromJson(envelope), equals(original));
    });

    test('formats a real address for display', () {
      final list = AddressModel.listFromJson(_realPayload);

      // Empty landmark/contact strings must not leave dangling separators.
      expect(
        list[1].formattedAddress,
        '12, 4, 4 Road # 28, Block # C, Banani, Dhaka 1213, Bangladesh, Gulshan, Dhaka, Gulshan',
      );
    });

    test('survives a cache round trip', () {
      final original = AddressModel.listFromJson({
        'data': [
          {
            'id': '7',
            'type': 'HOME',
            'latitude': '23.5',
            'longitude': '90.5',
            'is_default': false,
          },
        ],
      });

      final envelope = {
        'data': original.map((e) => e.toJson()).toList(),
      };

      expect(AddressModel.listFromJson(envelope), equals(original));
    });
  });
}
