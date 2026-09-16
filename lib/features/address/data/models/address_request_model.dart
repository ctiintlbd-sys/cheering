class AddressRequestModel {
  final String type;
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

  AddressRequestModel({
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

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      if (label != null) 'label': label,
      if (streetAddress != null) 'street_address': streetAddress,
      if (apartment != null) 'apartment': apartment,
      if (landmark != null) 'landmark': landmark,
      if (city != null) 'city': city,
      if (postalCode != null) 'postal_code': postalCode,
      if (contactPhone != null) 'contact_phone': contactPhone,
      'latitude': latitude,
      'longitude': longitude,
      'is_default': isDefault,
    };
  }
}
