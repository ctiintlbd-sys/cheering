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
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      isDefault: json['is_default'] == true,
    );
  }

  factory AddressModel.fromEntity(AddressEntity entity) {
    return AddressModel(
      id: entity.id,
      type: entity.type,
      label: entity.label,
      streetAddress: entity.streetAddress,
      apartment: entity.apartment,
      landmark: entity.landmark,
      city: entity.city,
      postalCode: entity.postalCode,
      contactPhone: entity.contactPhone,
      latitude: entity.latitude,
      longitude: entity.longitude,
      isDefault: entity.isDefault,
    );
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
