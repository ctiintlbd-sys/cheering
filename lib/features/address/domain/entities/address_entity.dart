import 'package:equatable/equatable.dart';

enum AddressType { home, work, other, unknown }

class AddressEntity extends Equatable {
  const AddressEntity({
    required this.id,
    required this.type,
    this.label,
    this.streetAddress,
    this.apartment,
    this.landmark,
    this.city,
    this.postalCode,
    this.contactPhone,
    required this.latitude,
    required this.longitude,
    required this.isDefault,
  });

  /// Id of the GPS-derived row, which only ever exists on the device.
  static const String currentLocationId = 'current_location';

  final String id;
  final AddressType type;
  final String? label;
  final String? streetAddress;
  final String? apartment;
  final String? landmark;
  final String? city;
  final String? postalCode;
  final String? contactPhone;
  final double latitude;
  final double longitude;
  final bool isDefault;

  bool get isCurrentLocation => id == currentLocationId;

  AddressEntity copyWith({
    String? id,
    AddressType? type,
    String? label,
    String? streetAddress,
    String? apartment,
    String? landmark,
    String? city,
    String? postalCode,
    String? contactPhone,
    double? latitude,
    double? longitude,
    bool? isDefault,
  }) {
    return AddressEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      label: label ?? this.label,
      streetAddress: streetAddress ?? this.streetAddress,
      apartment: apartment ?? this.apartment,
      landmark: landmark ?? this.landmark,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      contactPhone: contactPhone ?? this.contactPhone,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  factory AddressEntity.fromManualMap(
    Map<String, dynamic> map, {
    String id = currentLocationId,
    AddressType type = AddressType.other,
    bool isDefault = true,
  }) {
    return AddressEntity(
      id: id,
      type: type,
      label: map['area'] as String? ?? 'Current Location',
      streetAddress: map['address'] as String?,
      city: map['area'] as String?,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      isDefault: isDefault,
    );
  }

  @override
  List<Object?> get props => [
    id,
    type,
    label,
    streetAddress,
    apartment,
    landmark,
    city,
    postalCode,
    contactPhone,
    latitude,
    longitude,
    isDefault,
  ];
}

extension AddressFormatting on AddressEntity {
  String get formattedAddress {
    final parts = <String>[];
    if (apartment?.isNotEmpty == true) parts.add(apartment!);
    if (streetAddress?.isNotEmpty == true) parts.add(streetAddress!);
    if (landmark?.isNotEmpty == true) parts.add(landmark!);
    if (city?.isNotEmpty == true) {
      final cityLower = city!.toLowerCase();
      if (!parts.any((p) => p.toLowerCase().contains(cityLower))) {
        parts.add(city!);
      }
    }
    return parts.isNotEmpty ? parts.join(', ') : (label ?? '');
  }
}
