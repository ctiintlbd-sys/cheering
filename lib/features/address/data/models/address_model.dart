import 'package:flutter/foundation.dart';

import '../../domain/entities/address_entity.dart';

class AddressModel extends AddressEntity {
  const AddressModel({
    required super.id,
    required super.type,
    super.label,
    super.streetAddress,
    super.apartment,
    super.landmark,
    super.city,
    super.postalCode,
    super.contactPhone,
    required super.latitude,
    required super.longitude,
    required super.isDefault,
  });

  /// Reads the address list out of a response or cache envelope without
  /// throwing when `data` is absent, null, or nested one level deeper.
  static List<AddressModel> listFromJson(dynamic json) {
    dynamic node = json is Map ? json['data'] : json;
    if (node is Map) {
      node = node['addresses'] ?? node['items'] ?? node['data'];
    }
    if (node is! List) {
      debugPrint('[AddressModel] unexpected addresses payload: $json');
      return const [];
    }
    return node
        .whereType<Map>()
        .map((e) => AddressModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id']?.toString() ?? '',
      type: AddressType.values.firstWhere(
        (e) => e.name.toUpperCase() == json['type']?.toString().toUpperCase(),
        orElse: () => AddressType.unknown,
      ),
      label: json['label']?.toString(),
      streetAddress: json['street_address']?.toString(),
      apartment: json['apartment']?.toString(),
      landmark: json['landmark']?.toString(),
      city: json['city']?.toString(),
      postalCode: json['postal_code']?.toString(),
      contactPhone: json['contact_phone']?.toString(),
      latitude: _toDouble(json['latitude']),
      longitude: _toDouble(json['longitude']),
      isDefault: json['is_default'] == true,
    );
  }

  /// Decimal columns come back as strings from the API, so a plain `as num`
  /// cast would throw and turn a 200 into a parse failure.
  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name.toUpperCase(),
      'label': label,
      'street_address': streetAddress,
      'apartment': apartment,
      'landmark': landmark,
      'city': city,
      'postal_code': postalCode,
      'contact_phone': contactPhone,
      'latitude': latitude,
      'longitude': longitude,
      'is_default': isDefault,
    };
  }
}
