import 'address_entity.dart';

class AddressParams {
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

  const AddressParams({
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
  });
}
