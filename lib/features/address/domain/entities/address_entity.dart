import 'package:equatable/equatable.dart';

enum AddressType { home, work, other, unknown }

class AddressEntity extends Equatable {
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
